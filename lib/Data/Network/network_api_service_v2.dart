import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';

import '../../Settings/constants/app_url.dart';
import '../Exceptions/app_exceptions.dart';
import '../LocaStorage/loggedin_user.dart';
import 'base_api_service.dart';

class NetworkApiServiceV2 implements BaseApiService {
  NetworkApiServiceV2({dio.Dio? client}) : adapter = client ?? _sharedClient {
    if (client != null) _configureClient(adapter);
  }

  final dio.Dio adapter;

  static final dio.Dio _sharedClient = _createClient();
  static Future<bool>? _refreshInProgress;
  static const _retriedKey = 'authRetry';
  static const _retryCountKey = 'transientRetryCount';
  static const _maxTransientRetries = 2;

  @visibleForTesting
  static dio.Dio? refreshClientOverride;

  static VoidCallback? onAuthenticationFailed;

  static dio.Dio _createClient() {
    final client = dio.Dio(
      dio.BaseOptions(
        baseUrl: AppUrl.baseurl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        contentType: dio.Headers.jsonContentType,
      ),
    );
    _configureClient(client);
    return client;
  }

  static void _configureClient(dio.Dio client) {
    client.interceptors.clear();
    client.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_requiresAuthentication(options.path)) {
            if (_accessTokenNeedsRefresh() && await _refreshToken()) {
              options.headers['Authorization'] =
                  'Bearer ${LoggedInUser.accessToken}';
            } else if (LoggedInUser.accessToken?.isNotEmpty ?? false) {
              options.headers['Authorization'] =
                  'Bearer ${LoggedInUser.accessToken}';
            }
          }
          if (kDebugMode) {
            debugPrint('${options.method} ${options.uri}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) async {
          final bodyStatus =
              response.data is Map ? response.data['statusCode'] : null;
          if (bodyStatus == 401 &&
              await _retryAfterRefresh(
                  client, response.requestOptions, handler)) {
            return;
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              await _retryAfterRefresh(client, error.requestOptions, handler)) {
            return;
          }
          if (await _retryTransient(client, error, handler)) {
            return;
          }
          if (kDebugMode) {
            debugPrint(
              '${error.requestOptions.method} ${error.requestOptions.uri} '
              'failed (${error.response?.statusCode ?? error.type.name})',
            );
          }
          handler.next(error);
        },
      ),
    );
  }

  static bool _requiresAuthentication(String path) {
    return !path.endsWith(AppUrl.login) &&
        !path.endsWith(AppUrl.forgot) &&
        !path.endsWith(AppUrl.verifyOtp) &&
        !path.endsWith(AppUrl.reset) &&
        !path.endsWith(AppUrl.refreshToken);
  }

  static bool _accessTokenNeedsRefresh() {
    final expiry = LoggedInUser.accessTokenExpiry;
    return expiry != null &&
        DateTime.now().add(const Duration(seconds: 30)).isAfter(expiry);
  }

  static Future<bool> ensureValidSession() async {
    await LoggedInUser.getUserDetails();
    if (LoggedInUser.accessToken == null || LoggedInUser.accessToken!.isEmpty) {
      return false;
    }
    if (!LoggedInUser.isTokenExpired && !_accessTokenNeedsRefresh()) {
      return true;
    }
    return _refreshToken();
  }

  static Future<bool> _retryAfterRefresh(
    dio.Dio client,
    dio.RequestOptions request,
    dynamic handler,
  ) async {
    if (request.extra[_retriedKey] == true ||
        !_requiresAuthentication(request.path)) {
      return false;
    }
    if (!await _refreshToken()) return false;

    request.extra[_retriedKey] = true;
    request.headers['Authorization'] = 'Bearer ${LoggedInUser.accessToken}';
    try {
      final response = await client.fetch(request);
      handler.resolve(response);
      return true;
    } on dio.DioException catch (error) {
      handler.reject(error);
      return true;
    }
  }

  /// Retries timeouts, connection failures (SocketException on IO platforms
  /// surfaces as connectionError/unknown), and 502/503/504 responses.
  /// At most [_maxTransientRetries] attempts with exponential backoff.
  static bool _isTransient(dio.DioException error) {
    switch (error.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.sendTimeout:
      case dio.DioExceptionType.receiveTimeout:
      case dio.DioExceptionType.connectionError:
        return true;
      case dio.DioExceptionType.unknown:
        return error.error.toString().contains('SocketException');
      default:
        return const {502, 503, 504}.contains(error.response?.statusCode);
    }
  }

  static Future<bool> _retryTransient(
    dio.Dio client,
    dio.DioException error,
    dio.ErrorInterceptorHandler handler,
  ) async {
    if (!_isTransient(error)) return false;
    final request = error.requestOptions;
    final attempt = (request.extra[_retryCountKey] as int?) ?? 0;
    if (attempt >= _maxTransientRetries) return false;

    request.extra[_retryCountKey] = attempt + 1;
    await Future.delayed(Duration(milliseconds: 500 * (1 << attempt)));
    try {
      handler.resolve(await client.fetch(request));
    } on dio.DioException catch (retryError) {
      handler.reject(retryError);
    }
    return true;
  }

  static Future<bool> _refreshToken() {
    return _refreshInProgress ??= _performRefresh().whenComplete(
      () => _refreshInProgress = null,
    );
  }

  static Future<bool> _performRefresh() async {
    final refreshToken = LoggedInUser.refreshToken;
    if (refreshToken == null ||
        refreshToken.isEmpty ||
        LoggedInUser.isRefreshTokenExpired) {
      await _expireSession();
      return false;
    }

    // Reuse the shared client: the refresh endpoint is excluded from the auth
    // interceptor, so this cannot recurse.
    final refreshClient = refreshClientOverride ?? _sharedClient;
    try {
      final response = await refreshClient.post(
        AppUrl.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      final successful = response.statusCode == 200 &&
          response.data is Map &&
          (response.data['status'] == true ||
              response.data['statusCode'] == 200);
      if (!successful) {
        await _expireSession();
        return false;
      }
      await LoggedInUser.updateTokens(
        Map<String, dynamic>.from(response.data as Map),
      );
      return true;
    } on dio.DioException {
      await _expireSession();
      return false;
    }
  }

  static Future<void> _expireSession() async {
    await LoggedInUser.clearUserData();
    onAuthenticationFailed?.call();
  }

  dio.Options _options(Map<String, String>? headers, String? token) {
    return dio.Options(
      headers: {
        ...?headers,
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }

  String _endpoint(String endpoint, String? append) {
    return append == null ? endpoint : '$endpoint/$append';
  }

  @override
  Future<dynamic> getGetApiResponse(
    String endPoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
    String? appned,
  }) async {
    final response = await adapter.get(
      _endpoint(endPoint, appned),
      queryParameters: queryParameters,
      options: _options(headers, token),
    );
    return dioReturnResponse(response);
  }

  @override
  Future<dynamic> getPostApiResponse(
    String endPoint, {
    String? domain,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
    String? appned,
  }) async {
    final response = await adapter.post(
      _absoluteOrRelative(domain, _endpoint(endPoint, appned)),
      data: body,
      queryParameters: queryParameters,
      options: _options(headers, token),
    );
    return dioReturnResponse(response);
  }

  @override
  Future<dynamic> getPutApiResponse(
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
    String? appned,
  }) async {
    final response = await adapter.put(
      _endpoint(endpoint, appned),
      data: body,
      queryParameters: queryParameters,
      options: _options(headers, token),
    );
    return dioReturnResponse(response);
  }

  @override
  Future<dynamic> getPatchApiResponse(
    String endPoint, {
    String? domain,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
    String? appned,
  }) async {
    final response = await adapter.patch(
      _absoluteOrRelative(domain, _endpoint(endPoint, appned)),
      data: body,
      queryParameters: queryParameters,
      options: _options(headers, token),
    );
    return dioReturnResponse(response);
  }

  @override
  Future<dynamic> getDeleteApiResponse(
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
    String? appned,
  }) async {
    final response = await adapter.delete(
      _endpoint(endpoint, appned),
      data: body,
      queryParameters: queryParameters,
      options: _options(headers, token),
    );
    return dioReturnResponse(response);
  }

  @override
  Future<dynamic> putMethod(
    String url, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    final response = await adapter.put(
      url,
      data: body,
      queryParameters: queryParameters,
      options: _options(headers, token),
    );
    return dioReturnResponse(response);
  }

  @override
  Future<dynamic> getGetApiResponsewithBody(
    String endpoints, {
    String? domain,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    String? token,
    bool isHttps = false,
  }) async {
    final response = await adapter.get(
      _absoluteOrRelative(domain, endpoints),
      data: body,
      options: _options(headers, token),
    );
    return dioReturnResponse(response);
  }

  @override
  Future<Uint8List> fetchImage(String imageLink) async {
    final response = await adapter.get<List<int>>(
      imageLink,
      options: dio.Options(responseType: dio.ResponseType.bytes),
    );
    return Uint8List.fromList(response.data ?? const []);
  }

  @override
  Future<dynamic> formData(
    String endpoints, {
    String? domain,
    List<String> fileFields = const [],
    List<String?> filePaths = const [],
    Map<String, dynamic> body = const {},
    Map<String, String>? headers,
    String? token,
    bool isHttps = false,
  }) async {
    final data = Map<String, dynamic>.from(body);
    for (var index = 0; index < fileFields.length; index++) {
      final path = index < filePaths.length ? filePaths[index] : null;
      if (path != null) {
        data[fileFields[index]] = await dio.MultipartFile.fromFile(path);
      }
    }
    final response = await adapter.post(
      _absoluteOrRelative(domain, endpoints),
      data: dio.FormData.fromMap(data),
      options: _options(headers, token),
    );
    return dioReturnResponse(response);
  }

  @override
  Future<dynamic> formDataV1(
    String endpoints, {
    String? domain,
    List<String> fileFields = const [],
    List<Uint8List?> filePaths = const [],
    Map<String, dynamic> body = const {},
    Map<String, String>? headers,
    String? token,
    bool isHttps = false,
  }) async {
    final data = Map<String, dynamic>.from(body);
    for (var index = 0; index < fileFields.length; index++) {
      final bytes = index < filePaths.length ? filePaths[index] : null;
      if (bytes != null) {
        data[fileFields[index]] = dio.MultipartFile.fromBytes(
          bytes,
          filename: '${fileFields[index]}.bin',
        );
      }
    }
    final response = await adapter.post(
      _absoluteOrRelative(domain, endpoints),
      data: dio.FormData.fromMap(data),
      options: _options(headers, token),
    );
    return dioReturnResponse(response);
  }

  @override
  Future<Uint8List> formDataV2(
    String endpoints, {
    String? domain,
    List<String> fileFields = const [],
    List<String?> filePaths = const [],
    Map<String, dynamic> body = const {},
    Map<String, String>? headers,
    String? token,
    bool isHttps = false,
  }) async {
    final response = await formData(
      endpoints,
      domain: domain,
      fileFields: fileFields,
      filePaths: filePaths,
      body: body,
      headers: headers,
      token: token,
      isHttps: isHttps,
    );
    if (response is Uint8List) return response;
    if (response is List<int>) return Uint8List.fromList(response);
    throw const FormatException('Expected a byte response.');
  }

  @override
  Future<Map<String, dynamic>> formDataMultiFile(
    String endpoints, {
    String? domain,
    List<String?> filePaths = const [],
    List<String> fileFields = const [],
    Map<String, dynamic> body = const {},
    Map<String, String>? headers,
    String? token,
    bool isHttps = false,
  }) async {
    final response = await formData(
      endpoints,
      domain: domain,
      fileFields: fileFields,
      filePaths: filePaths,
      body: body,
      headers: headers,
      token: token,
      isHttps: isHttps,
    );
    return Map<String, dynamic>.from(response as Map);
  }

  String _absoluteOrRelative(String? domain, String endpoint) {
    if (domain == null || domain.isEmpty) return endpoint;
    final base =
        domain.endsWith('/') ? domain.substring(0, domain.length - 1) : domain;
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return '$base$path';
  }

  dynamic dioReturnResponse(dio.Response<dynamic> response) {
    final message = response.data is Map ? response.data['message'] : null;
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 204:
        return response.data;
      case 400:
        throw BadRequestException(message, response.statusCode);
      case 401:
      case 403:
        throw UnauthorisedException(message, response.statusCode);
      default:
        throw FetchDataException(
          message ?? 'Request failed',
          response.statusCode,
        );
    }
  }
}
