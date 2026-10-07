import 'package:shared_preferences/shared_preferences.dart';

import 'token_storage.dart';

class LoggedInUser {
  static String? id;
  static bool? documentStatus;
  static String? adminUserName;
  static String? adminUserType;
  static String? email;
  static String? role;
  static String? accessToken;
  static String? refreshToken;
  static DateTime? accessTokenExpiry;
  static DateTime? refreshTokenExpiry;
  static DateTime? createdAt;
  static DateTime? updatedAt;

  LoggedInUser.login(Map<String, dynamic> json) {
    _parseLoginResponse(json);
    storeUserLocally();
  }

  static Future<void> loginFromResponse(Map<String, dynamic> json) async {
    _parseLoginResponse(json);
    await storeUserLocally();
  }

  static Future<void> updateTokens(Map<String, dynamic> response) async {
    final data = _asMap(response['data']);
    final tokens = _asMap(data['tokens']);
    final access = _asMap(tokens['access']);
    final refresh = _asMap(tokens['refresh']);

    final nextAccessToken =
        _tokenValue(data['accessToken']) ?? _tokenValue(access['token']);
    final nextRefreshToken =
        _tokenValue(data['refreshToken']) ?? _tokenValue(refresh['token']);
    if (nextAccessToken == null) {
      throw const FormatException('Refresh response has no access token.');
    }

    accessToken = nextAccessToken;
    refreshToken = nextRefreshToken ?? refreshToken;
    accessTokenExpiry = _parseDate(
          data['accessTokenExpiry'] ?? access['expires'] ?? access['expiry'],
        ) ??
        TokenStorage.jwtExpiry(nextAccessToken);
    refreshTokenExpiry = _parseDate(
          data['refreshTokenExpiry'] ?? refresh['expires'] ?? refresh['expiry'],
        ) ??
        TokenStorage.jwtExpiry(refreshToken ?? '');
    await storeUserLocally();
  }

  static void _parseLoginResponse(Map<String, dynamic> json) {
    if (json['status'] != true) {
      throw Exception('Login failed: ${json['message']}');
    }

    final data = _asMap(json['data']);
    final userData = _asMap(data['user']);
    if (userData.isEmpty) {
      throw const FormatException('User data is missing.');
    }

    final tokens = _asMap(data['tokens']);
    final access = _asMap(tokens['access']);
    final refresh = _asMap(tokens['refresh']);

    id = userData['id']?.toString();
    documentStatus = userData['documentStatus'] as bool? ?? false;
    adminUserName = userData['adminUserName']?.toString();
    adminUserType = userData['adminUserType']?.toString();
    email = userData['email']?.toString();
    role = userData['role']?.toString();
    createdAt = _parseDate(userData['createdAt']);
    updatedAt = _parseDate(userData['updatedAt']);

    accessToken = _tokenValue(data['accessToken']) ??
        _tokenValue(access['token']) ??
        accessToken;
    refreshToken = _tokenValue(data['refreshToken']) ??
        _tokenValue(refresh['token']) ??
        refreshToken;
    accessTokenExpiry = _parseDate(
          data['accessTokenExpiry'] ?? access['expires'] ?? access['expiry'],
        ) ??
        TokenStorage.jwtExpiry(accessToken ?? '');
    refreshTokenExpiry = _parseDate(
          data['refreshTokenExpiry'] ?? refresh['expires'] ?? refresh['expiry'],
        ) ??
        TokenStorage.jwtExpiry(refreshToken ?? '');

    if (accessToken == null || accessToken!.isEmpty) {
      throw const FormatException('Access token is missing.');
    }
  }

  static DateTime? _parseDate(dynamic dateValue) {
    if (dateValue == null) return null;
    if (dateValue is num) {
      final milliseconds = dateValue > 100000000000
          ? dateValue.toInt()
          : dateValue.toInt() * 1000;
      return DateTime.fromMillisecondsSinceEpoch(milliseconds).toLocal();
    }
    return DateTime.tryParse(dateValue.toString())?.toLocal();
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    return value is Map ? Map<String, dynamic>.from(value) : const {};
  }

  static String? _tokenValue(dynamic value) {
    final token = value?.toString();
    return token == null || token.isEmpty ? null : token;
  }

  static Future<void> storeUserLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString('id', id ?? ''),
      prefs.setBool('documentStatus', documentStatus ?? false),
      prefs.setString('adminUserName', adminUserName ?? ''),
      prefs.setString('adminUserType', adminUserType ?? ''),
      prefs.setString('email', email ?? ''),
      prefs.setString('role', role ?? ''),
    ]);
    await _writeOptionalDate(prefs, 'createdAt', createdAt);
    await _writeOptionalDate(prefs, 'updatedAt', updatedAt);
    await TokenStorage.write(
      StoredTokens(
        accessToken: accessToken ?? '',
        refreshToken: refreshToken ?? '',
        accessTokenExpiry: accessTokenExpiry,
        refreshTokenExpiry: refreshTokenExpiry,
      ),
    );
  }

  static Future<void> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final tokens = await TokenStorage.read();

    id = prefs.getString('id');
    documentStatus = prefs.getBool('documentStatus');
    adminUserName = prefs.getString('adminUserName');
    adminUserType = prefs.getString('adminUserType');
    email = prefs.getString('email');
    role = prefs.getString('role');
    accessToken = tokens.accessToken;
    refreshToken = tokens.refreshToken;
    createdAt = DateTime.tryParse(prefs.getString('createdAt') ?? '');
    updatedAt = DateTime.tryParse(prefs.getString('updatedAt') ?? '');
    accessTokenExpiry = tokens.accessTokenExpiry;
    refreshTokenExpiry = tokens.refreshTokenExpiry;
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove('id'),
      prefs.remove('documentStatus'),
      prefs.remove('adminUserName'),
      prefs.remove('adminUserType'),
      prefs.remove('email'),
      prefs.remove('role'),
      prefs.remove('createdAt'),
      prefs.remove('updatedAt'),
      TokenStorage.clear(),
    ]);

    id = null;
    documentStatus = null;
    adminUserName = null;
    adminUserType = null;
    email = null;
    role = null;
    accessToken = null;
    refreshToken = null;
    accessTokenExpiry = null;
    refreshTokenExpiry = null;
    createdAt = null;
    updatedAt = null;
  }

  static bool get isLoggedIn =>
      accessToken != null && accessToken!.isNotEmpty && !isTokenExpired;

  static bool get isAdmin => role == 'admin';

  static bool get isTokenExpired {
    if (accessToken == null || accessToken!.isEmpty) return true;
    final expiry =
        accessTokenExpiry ?? TokenStorage.jwtExpiry(accessToken ?? '');
    return expiry != null && DateTime.now().isAfter(expiry);
  }

  static bool get isRefreshTokenExpired {
    if (refreshToken == null || refreshToken!.isEmpty) return true;
    final expiry =
        refreshTokenExpiry ?? TokenStorage.jwtExpiry(refreshToken ?? '');
    return expiry != null && DateTime.now().isAfter(expiry);
  }

  static bool get isRefreshTokenAvailable =>
      refreshToken != null && !isRefreshTokenExpired;

  static Future<bool> _writeOptionalDate(
    SharedPreferences prefs,
    String key,
    DateTime? value,
  ) {
    return value == null
        ? prefs.remove(key)
        : prefs.setString(key, value.toIso8601String());
  }
}
