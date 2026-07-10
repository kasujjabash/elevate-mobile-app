import 'dart:convert';
import 'package:era92_elevate/services/session_service.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:4002/api';

  /// Attempts to log in. Saves the returned user data into [SessionService]
  /// so the rest of the app can access it. Returns the decoded response body.
  /// Throws an [Exception] with a readable message on failure.
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

    late final http.Response response;

    try {
      response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception('Network error. Check your connection.');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // ── Save logged-in user data into session ──────────────────────────────
      SessionService.instance.saveFromLoginResponse(data);

      return data;
    } else if (response.statusCode == 401) {
      throw Exception('Invalid username or password');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  /// Call this on logout to wipe the session.
  static void logout() {
    SessionService.instance.clear();
  }
}
