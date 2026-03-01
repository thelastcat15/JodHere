import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  String? _accessToken;
  String? _refreshToken;
  DateTime? _expiresAt;

  bool get isLoggedIn {
    if (_accessToken == null) return false;
    if (_expiresAt == null) return true;
    return DateTime.now().isBefore(_expiresAt!);
  }

  void logout() {
    _accessToken = null;
    _refreshToken = null;
    _expiresAt = null;
  }

  void setSession({required String accessToken, String? refreshToken, int? expiresIn}) {
    _accessToken = accessToken;
    if (refreshToken != null) _refreshToken = refreshToken;
    if (expiresIn != null) {
      _expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    }
  }

  String? getAccessToken() => _accessToken;
  String? getRefreshToken() => _refreshToken;

  Future<bool> refresh() async {
    final refresh = _refreshToken;
    if (refresh == null) return false;

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (supabaseUrl == null || anonKey == null) return false;

    final uri = Uri.parse('$supabaseUrl/auth/v1/token');
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'apikey': anonKey,
      },
      body: 'grant_type=refresh_token&refresh_token=$refresh',
    );

    if (res.statusCode != 200) return false;

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final access = json['access_token'] as String?;
    final newRefresh = json['refresh_token'] as String?;
    final expiresIn = json['expires_in'] as int?;

    if (access == null) return false;

    setSession(accessToken: access, refreshToken: newRefresh ?? refresh, expiresIn: expiresIn);
    return true;
  }
}

final authService = AuthService();
