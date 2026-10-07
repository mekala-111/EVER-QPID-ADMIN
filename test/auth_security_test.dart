import 'dart:convert';

import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Data/Network/base_api_service.dart';
import 'package:everqpidadmin/Features/auth/repository/auth_repository.dart';
import 'package:everqpidadmin/Features/auth/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LoggedInUser.clearUserData();
  });

  test('login stores access token, refresh token, and JWT expiry', () async {
    final accessToken = _jwt(DateTime.now().add(const Duration(minutes: 10)));
    final refreshToken = _jwt(DateTime.now().add(const Duration(days: 7)));
    final repository = AuthRepository(
      _LoginApi({
        'status': true,
        'data': {
          'user': {'id': 'admin-1', 'role': 'admin'},
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        },
      }),
    );

    await repository.login(email: 'admin@example.com', passwords: 'password');
    await LoggedInUser.getUserDetails();

    expect(LoggedInUser.accessToken, accessToken);
    expect(LoggedInUser.refreshToken, refreshToken);
    expect(LoggedInUser.accessTokenExpiry, isNotNull);
    expect(LoggedInUser.refreshTokenExpiry, isNotNull);
    expect(LoggedInUser.isLoggedIn, isTrue);
  });

  test('refresh response updates tokens without dropping refresh token',
      () async {
    final oldRefresh = _jwt(DateTime.now().add(const Duration(days: 7)));
    LoggedInUser.refreshToken = oldRefresh;

    await LoggedInUser.updateTokens({
      'data': {
        'tokens': {
          'access': {
            'token': _jwt(DateTime.now().add(const Duration(minutes: 10))),
          },
        },
      },
    });

    expect(LoggedInUser.accessToken, isNotEmpty);
    expect(LoggedInUser.refreshToken, oldRefresh);
  });

  test('logout clears the complete session', () async {
    LoggedInUser.accessToken = 'access';
    LoggedInUser.refreshToken = 'refresh';
    await LoggedInUser.storeUserLocally();

    await AuthService.logout();

    expect(LoggedInUser.accessToken, isNull);
    expect(LoggedInUser.refreshToken, isNull);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('accessToken'), isNull);
    expect(prefs.getString('refreshToken'), isNull);
  });
}

String _jwt(DateTime expiry) {
  String part(Object value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  return '${part({'alg': 'none'})}.'
      '${part({'exp': expiry.millisecondsSinceEpoch ~/ 1000})}.signature';
}

class _LoginApi implements BaseApiService {
  _LoginApi(this.response);

  final Map<String, dynamic> response;

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
    return response;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
