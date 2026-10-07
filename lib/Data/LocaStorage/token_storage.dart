import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StoredTokens {
  const StoredTokens({
    required this.accessToken,
    required this.refreshToken,
    this.accessTokenExpiry,
    this.refreshTokenExpiry,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime? accessTokenExpiry;
  final DateTime? refreshTokenExpiry;

  bool get hasAccessToken => accessToken.isNotEmpty;
  bool get hasRefreshToken => refreshToken.isNotEmpty;

  bool accessTokenExpiresWithin(Duration duration) {
    final expiry = accessTokenExpiry;
    return expiry != null && DateTime.now().add(duration).isAfter(expiry);
  }

  bool get refreshTokenExpired {
    final expiry = refreshTokenExpiry;
    return expiry != null && DateTime.now().isAfter(expiry);
  }
}

class TokenStorage {
  TokenStorage._();

  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _accessTokenExpiryKey = 'accessTokenExpiry';
  static const _refreshTokenExpiryKey = 'refreshTokenExpiry';

  static Future<StoredTokens> read() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(_accessTokenKey) ?? '';
    final refreshToken = prefs.getString(_refreshTokenKey) ?? '';

    return StoredTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessTokenExpiry: _readExpiry(
        prefs.getString(_accessTokenExpiryKey),
        accessToken,
      ),
      refreshTokenExpiry: _readExpiry(
        prefs.getString(_refreshTokenExpiryKey),
        refreshToken,
      ),
    );
  }

  static Future<void> write(StoredTokens tokens) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_accessTokenKey, tokens.accessToken),
      prefs.setString(_refreshTokenKey, tokens.refreshToken),
      _writeOptionalDate(
        prefs,
        _accessTokenExpiryKey,
        tokens.accessTokenExpiry ?? jwtExpiry(tokens.accessToken),
      ),
      _writeOptionalDate(
        prefs,
        _refreshTokenExpiryKey,
        tokens.refreshTokenExpiry ?? jwtExpiry(tokens.refreshToken),
      ),
    ]);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_accessTokenKey),
      prefs.remove(_refreshTokenKey),
      prefs.remove(_accessTokenExpiryKey),
      prefs.remove(_refreshTokenExpiryKey),
    ]);
  }

  static DateTime? jwtExpiry(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;

    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final expiry = payload is Map<String, dynamic> ? payload['exp'] : null;
      if (expiry is num) {
        return DateTime.fromMillisecondsSinceEpoch(
          expiry.toInt() * 1000,
          isUtc: true,
        ).toLocal();
      }
    } on FormatException {
      return null;
    }
    return null;
  }

  static DateTime? _readExpiry(String? storedValue, String token) {
    return DateTime.tryParse(storedValue ?? '') ?? jwtExpiry(token);
  }

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
