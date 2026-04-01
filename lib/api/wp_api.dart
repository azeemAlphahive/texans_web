import 'dart:convert';

import 'package:http/http.dart' as http;

class WpApi {
  WpApi._();

  static Uri _uri(String path, [Map<String, String>? query]) {
    final base = "https://texans-baseball-backend.up.railway.app";
    return Uri.parse('$base$path').replace(queryParameters: query);
  }

  /// Accept coach invitation with password in body
  static Future<http.Response> acceptInvitation({
    required String email,
    required String otp,
    required String action,
    required String password,
    required String confirmPassword,
  }) {
    final query = <String, String>{
      'email': email,
      'otp': otp,
      'action': action,
    };

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

  static Future<http.Response> parentInvitationAccept({
    required String invitationToken,
  }) {
    final query = <String, String>{'invitation_token': invitationToken};
    return http.get(
      _uri('/api/v1/parent/auth/invitation/accept', query),
      headers: {'Accept': 'application/json'},
    );
  }

  /// Set parent password after invitation
  static Future<http.Response> parentsetPass({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
    required String action,
  }) {
    final query = <String, String>{
      'email': email,
      'otp': otp,
      'action': action,
    };

    final body = {'password': password, 'confirm_password': confirmPassword};

    return http.post(
      _uri('/api/v1/parent/auth/reset-password', query),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  /// Decline coach invitation
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

  /// Decline parent invitation
  static Future<http.Response> parentDeclineInvitation({
    required String email,
  }) {
    return http.post(
      _uri('/api/v1/parent/auth/forgot-password'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email}),
    );
  }
}
