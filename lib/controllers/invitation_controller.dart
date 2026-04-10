import 'package:get/get.dart';
import 'package:texans_web/api/wp_api.dart';
import 'package:texans_web/theme/wp_snackbar.dart';
import 'package:texans_web/utils/api_response_message.dart';

class InvitationController extends GetxController {
  final RxString email = ''.obs;
  final RxString otp = ''.obs;
  final RxString action = 'set'.obs;

  /// When true, [acceptInvitation] is not used — call [parentSetPassword] instead
  /// (parent must use `/api/v1/parent/auth/reset-password`, not coach).
  final bool isParentFlow;

  final RxBool isAcceptLoading = false.obs;
  final RxBool isDeclineLoading = false.obs; // ← separate loader

  InvitationController({
    required String email,
    required String otp,
    String action = 'set',
    this.isParentFlow = false,
  }) {
    this.email.value = email.trim();
    this.otp.value = otp.trim();
    this.action.value = action.trim().isEmpty ? 'set' : action.trim();
  }

  /// Parent: set password after email link (same screen as coach when `flow=parent`).
  Future<bool> parentSetPassword({
    required String password,
    required String confirmPassword,
  }) async {
    isAcceptLoading.value = true;
    try {
      final response = await WpApi.parentsetPass(
        email: email.value,
        otp: otp.value,
        password: password,
        confirmPassword: confirmPassword,
        action: action.value,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final msg = messageFromApiBody(response.body) ??
            'Account created successfully!';
        WpSnackbar.success('Success', msg);
        return true;
      } else {
        _showErrorFromResponse(
          response.body,
          fallback: 'Could not create your account. Please try again.',
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
        final msg = messageFromApiBody(response.body) ??
            'Account created successfully!';
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
        final msg = messageFromApiBody(response.body) ??
            'You have declined the invitation.';
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

  /// ❌ Decline parent invitation
  Future<bool> declineParentInvitation() async {
    isDeclineLoading.value = true;
    try {
      final response = await WpApi.parentDeclineInvitation(email: email.value);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final msg = messageFromApiBody(response.body) ??
            'You have declined the invitation.';
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
    WpSnackbar.error(
      'Error',
      userFacingApiMessage(body, fallback),
    );
  }

  void _showNetworkError() {
    WpSnackbar.error('Error', 'Network error. Please try again.');
  }
}
