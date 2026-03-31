import 'dart:convert';

import 'package:http/http.dart' as http;

class WpApi {
  WpApi._();

  static Uri _uri(String path, [Map<String, String>? query]) {
    final base = "https://texans-baseball-backend.up.railway.app";
    return Uri.parse('$base$path').replace(queryParameters: query);
  }

  /// Accept invitation with password in body
  static Future<http.Response> acceptInvitation({
    required String email,
    required String otp,
    required String action,
    required String password,
    required String confirmPassword,
  }) {
    // Query parameters
    final query = <String, String>{
      'email': email,
      'otp': otp,
      'action': action,
    };

    // Body parameters
    final body = {'password': password, 'confirm_password': confirmPassword};

    return http.post(
      _uri('/api/v1/coach/auth/reset-password', query),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  /// Decline invitation - POST with email in body
  static Future<http.Response> declineInvitation({required String email}) {
    return http.post(
      _uri('/api/v1/coach/auth/forgot-password'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email}),
    );
  }
}
