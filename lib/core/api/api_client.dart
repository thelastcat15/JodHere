import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:jodhere/core/api/api_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiClient {
  final SupabaseClient _supabase;
  final Duration timeout;

  ApiClient(
    this._supabase, {
    this.timeout = const Duration(seconds: 30),
  });

  /// ===============================
  /// Public Methods
  /// ===============================

  Future<Map<String, dynamic>> get(String path) {
    return _request("GET", path);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) {
    return _request("POST", path, body: body);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) {
    return _request("PUT", path, body: body);
  }

  Future<Map<String, dynamic>> delete(String path) {
    return _request("DELETE", path);
  }

  /// ===============================
  /// Core Request Logic
  /// ===============================

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final session = _supabase.auth.currentSession;

    if (session == null) {
      throw Exception("Not authenticated");
    }

    final uri = Uri.parse("${ApiConfig.baseUrl}$path");

    http.Response response = await _sendRequest(
      method,
      uri,
      session.accessToken,
      body,
    );

    /// 🔁 Auto refresh on 401
    if (response.statusCode == 401) {
      final refresh = await _supabase.auth.refreshSession();
      final newSession = refresh.session;

      if (newSession == null) {
        throw Exception("Session expired");
      }

      response = await _sendRequest(
        method,
        uri,
        newSession.accessToken,
        body,
      );
    }

    return _handleResponse(response);
  }

  /// ===============================
  /// HTTP Sender
  /// ===============================

  Future<http.Response> _sendRequest(
    String method,
    Uri uri,
    String accessToken,
    Map<String, dynamic>? body,
  ) {
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    switch (method) {
      case "GET":
        return http.get(uri, headers: headers).timeout(timeout);

      case "POST":
        return http
            .post(uri, headers: headers, body: jsonEncode(body))
            .timeout(timeout);

      case "PUT":
        return http
            .put(uri, headers: headers, body: jsonEncode(body))
            .timeout(timeout);

      case "DELETE":
        return http.delete(uri, headers: headers).timeout(timeout);

      default:
        throw Exception("Unsupported HTTP method");
    }
  }

  /// ===============================
  /// Response Handler
  /// ===============================

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = utf8.decode(response.bodyBytes);

    if (statusCode >= 200 && statusCode < 300) {
      if (responseBody.isEmpty) {
        return {};
      }
      return jsonDecode(responseBody);
    }

    throw Exception(
      "API Error [$statusCode]: $responseBody",
    );
  }
}