import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'api_config.dart';

class ApiClient {
  final SupabaseClient _supabase;

  ApiClient(this._supabase);

  Future<Map<String, dynamic>> get(String path) async {
    final session = _supabase.auth.currentSession;

    if (session == null) {
      throw Exception("Not authenticated");
    }

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}$path"),
      headers: {
        "Authorization": "Bearer ${session.accessToken}",
      },
    );

    if (response.statusCode == 401) {
      final res = await _supabase.auth.refreshSession();
      final newSession = res.session;

      if (newSession == null) {
        throw Exception("Session expired");
      }

      final retry = await http.get(
        Uri.parse("${ApiConfig.baseUrl}$path"),
        headers: {
          "Authorization": "Bearer ${newSession.accessToken}",
        },
      );

      return jsonDecode(retry.body);
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }

    throw Exception("API Error: ${response.body}");
  }
}