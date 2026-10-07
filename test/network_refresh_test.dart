import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LoggedInUser.clearUserData();
  });

  tearDown(() {
    NetworkApiServiceV2.refreshClientOverride = null;
  });

  test('401 refreshes once, saves tokens, and retries original request',
      () async {
    LoggedInUser.accessToken = 'old-access';
    LoggedInUser.refreshToken = _jwt(
      DateTime.now().add(const Duration(days: 1)),
    );
    LoggedInUser.accessTokenExpiry =
        DateTime.now().add(const Duration(minutes: 5));
    LoggedInUser.refreshTokenExpiry =
        DateTime.now().add(const Duration(days: 1));
    await LoggedInUser.storeUserLocally();

    final requestAdapter = _SequenceAdapter([
      _jsonResponse(401, {'message': 'expired'}),
      _jsonResponse(200, {'status': true}),
    ]);
    final requestClient = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..httpClientAdapter = requestAdapter;

    final refreshedAccess = _jwt(
      DateTime.now().add(const Duration(minutes: 10)),
    );
    final refreshedRefresh = _jwt(
      DateTime.now().add(const Duration(days: 2)),
    );
    final refreshClient = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..httpClientAdapter = _SequenceAdapter([
        _jsonResponse(200, {
          'status': true,
          'data': {
            'accessToken': refreshedAccess,
            'refreshToken': refreshedRefresh,
          },
        }),
      ]);
    NetworkApiServiceV2.refreshClientOverride = refreshClient;

    final service = NetworkApiServiceV2(client: requestClient);
    final result = await service.getGetApiResponse('protected');

    expect(result['status'], isTrue);
    expect(requestAdapter.requests, 2);
    expect(LoggedInUser.accessToken, refreshedAccess);
    expect(LoggedInUser.refreshToken, refreshedRefresh);
  });
}

ResponseBody _jsonResponse(int statusCode, Map<String, dynamic> body) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

String _jwt(DateTime expiry) {
  String part(Object value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  return '${part({'alg': 'none'})}.'
      '${part({'exp': expiry.millisecondsSinceEpoch ~/ 1000})}.signature';
}

class _SequenceAdapter implements HttpClientAdapter {
  _SequenceAdapter(this.responses);

  final List<ResponseBody> responses;
  int requests = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return responses[requests++];
  }

  @override
  void close({bool force = false}) {}
}
