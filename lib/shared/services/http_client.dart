import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth.dart';

/// HTTP client wrapper that automatically attaches `Authorization: Bearer <token>`
/// and attempts to refresh the token via `authService.refresh()` when needed.
class AuthHttpClient {
  final http.Client _inner = http.Client();

  void close() => _inner.close();

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return _send(() => _inner.get(url, headers: _headersWithAuth(headers)));
  }

  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return _send(() => _inner.post(url,
        headers: _headersWithAuth(headers), body: body, encoding: encoding));
  }

  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return _send(() => _inner.put(url,
        headers: _headersWithAuth(headers), body: body, encoding: encoding));
  }

  Future<http.Response> delete(Uri url, {Map<String, String>? headers}) async {
    return _send(() => _inner.delete(url, headers: _headersWithAuth(headers)));
  }

  Map<String, String> _headersWithAuth(Map<String, String>? headers) {
    final out = <String, String>{};
    if (headers != null) out.addAll(headers);
    final token = authService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      out['Authorization'] = 'Bearer $token';
    }
    return out;
  }

  Future<void> _ensureToken() async {
    // If access token expired or missing, try refresh
    if (!authService.isLoggedIn && authService.getRefreshToken() != null) {
      await authService.refresh();
    }
  }

  Future<http.Response> _send(Future<http.Response> Function() fn) async {
    await _ensureToken();
    var res = await fn();

    // If unauthorized, try refreshing and retry once
    if (res.statusCode == 401) {
      final refreshed = await authService.refresh();
      if (refreshed) {
        res = await fn();
      }
    }

    return res;
  }
}

final authHttpClient = AuthHttpClient();
