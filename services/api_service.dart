// lib/services/api_service.dart
//
// The one place in the app that knows how to talk HTTP to your Django
// backend. Screens never call `http.post` directly — they call methods
// on this class, so if the API shape ever changes, you fix it in one
// file instead of hunting through every screen.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class ApiService {
  // IMPORTANT: change this to your PC's current LAN IP — the same one
  // you pass to `flutter run --web-hostname=...`. Run `ipconfig` if
  // you're not sure, since it can change when you reconnect to WiFi.
  static const String baseUrl = 'http://192.168.0.107:8000/api';

  static const _storage = FlutterSecureStorage();

  static Future<String?> get accessToken => _storage.read(key: 'access_token');

  static Future<Map<String, String>> _authHeaders() async {
    final token = await accessToken;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Reads the error message DRF sends back (e.g. "username already
  /// taken") so the UI can show something more useful than a raw
  /// status code.
  static String _extractError(http.Response res) {
    try {
      final data = jsonDecode(res.body);
      if (data is Map) {
        // DRF error bodies look like {"username": ["already exists"]}
        // or {"detail": "..."}. This grabs whichever is present.
        final firstValue = data.values.isNotEmpty ? data.values.first : null;
        if (firstValue is List && firstValue.isNotEmpty) return firstValue.first.toString();
        if (data['detail'] != null) return data['detail'].toString();
      }
    } catch (_) {/* fall through to generic message */}
    return 'Something went wrong (${res.statusCode}).';
  }

  static Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );
    if (res.statusCode != 201) {
      throw ApiException(_extractError(res));
    }
  }

  static Future<void> login({
    required String username,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (res.statusCode != 200) {
      throw ApiException('Incorrect username or password.');
    }
    final data = jsonDecode(res.body);
    await _storage.write(key: 'access_token', value: data['access']);
    await _storage.write(key: 'refresh_token', value: data['refresh']);
    await _storage.write(key: 'username', value: username);
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'username');
  }

  static Future<String?> get currentUsername => _storage.read(key: 'username');
}
