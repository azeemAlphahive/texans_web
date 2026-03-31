import 'dart:convert';
import 'package:get/get.dart';
import 'package:texans_web/api/wp_api.dart';
import 'package:texans_web/theme/wp_snackbar.dart';

class InvitationController extends GetxController {
  final RxString email = ''.obs;
  final RxString otp = ''.obs;
  final RxString action = 'set'.obs;

  final RxBool isAcceptLoading = false.obs;
  final RxBool isDeclineLoading = false.obs; // ← separate loader

  InvitationController({
    required String email,
    required String otp,
    String action = 'set',
  }) {
    this.email.value = email.trim();
    this.otp.value = otp.trim();
    this.action.value = action;
  }

  /// ✅ Accept Invitation (Set Password)
  Future<bool> acceptInvitation({
    required String password,
    required String confirmPassword,
  }) async {
    isAcceptLoading.value = true;
    try {
      final response = await WpApi.acceptInvitation(
        email: email.value,
        otp: otp.value,
        action: action.value,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final msg = _messageFromBody(response.body) ?? 'Account created successfully!';
        WpSnackbar.success('Success', msg);
        return true;
      } else {
        _showErrorFromResponse(
          response.body,
          fallback: 'Failed to create account',
        );
        return false;
      }
    } catch (_) {
      _showNetworkError();
      return false;
    } finally {
      isAcceptLoading.value = false;
    }
  }

  /// ❌ Decline Invitation
  Future<bool> declineInvitation() async {
    isDeclineLoading.value = true;
    try {
      final response = await WpApi.declineInvitation(email: email.value);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final msg = _messageFromBody(response.body) ?? 'You have declined the invitation.';
        WpSnackbar.success('Success', msg);
        return true;
      } else {
        _showErrorFromResponse(
          response.body,
          fallback: 'Failed to decline invitation',
        );
        return false;
      }
    } catch (_) {
      _showNetworkError();
      return false;
    } finally {
      isDeclineLoading.value = false;
    }
  }

  // ── Private helpers ──────────────────────────────────────────────

  void _showErrorFromResponse(String body, {required String fallback}) {
    final message = _messageFromBody(body) ?? (body.trim().isNotEmpty ? body.trim() : fallback);
    WpSnackbar.error('Error', message);
  }

  void _showNetworkError() {
    WpSnackbar.error('Error', 'Network error. Please try again.');
  }
}

/// Parses common API JSON shapes for a human-readable message.
String? _messageFromBody(String body) {
  if (body.trim().isEmpty) return null;
  try {
    final parsed = jsonDecode(body);
    return _messageFromJson(parsed);
  } catch (_) {
    return null;
  }
}

String? _messageFromJson(dynamic parsed) {
  if (parsed is! Map) return null;
  final map = Map<String, dynamic>.from(parsed);

  final message = map['message'];
  if (message is String && message.trim().isNotEmpty) return message.trim();

  final error = map['error'];
  if (error is String && error.trim().isNotEmpty) return error.trim();
  if (error is List && error.isNotEmpty) {
    final first = error.first;
    if (first is String) return first;
    return first?.toString();
  }

  final errors = map['errors'];
  if (errors is Map) {
    for (final v in errors.values) {
      if (v is List && v.isNotEmpty) {
        final first = v.first;
        if (first is String) return first;
        return first?.toString();
      }
      if (v is String && v.isNotEmpty) return v;
    }
  }

  final data = map['data'];
  if (data is Map) {
    final dm = data['message'];
    if (dm is String && dm.trim().isNotEmpty) return dm.trim();
  }

  return null;
}
