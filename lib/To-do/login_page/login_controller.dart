import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginController {
  Future<String?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://dev-api-v2.s3-app.com/api/v1/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'skip_otp': true,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        List<dynamic> data = result['data'];
        String token = data[0]["token"];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return null; // Login successful
      } else {
        Map<String, dynamic> result = jsonDecode(response.body);
        return result['message'] ?? 'Login failed';
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 'An error occurred. Please try again.';
    }
  }
}
