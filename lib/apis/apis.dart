import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // For now, pointing at the practice API.
  // Later, you'll just change this one line to your NestJS server URL.
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static Future<List<dynamic>> fetchUsers() async {
    final url = Uri.parse('$baseUrl/users');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
