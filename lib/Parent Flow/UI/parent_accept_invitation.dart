import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texans_web/api/wp_api.dart';
import 'package:texans_web/routes/app_routes.dart';
import 'package:texans_web/theme/wp_snackbar.dart';
import 'package:texans_web/utils/api_response_message.dart';
import 'package:texans_web/widgets/wp_button.dart';

class ParentAcceptInvitationPage extends StatefulWidget {
  const ParentAcceptInvitationPage({super.key});

  @override
  State<ParentAcceptInvitationPage> createState() =>
      _ParentAcceptInvitationPageState();
}

class _ParentAcceptInvitationPageState
    extends State<ParentAcceptInvitationPage> {
  late final String _invitationToken;
  late final String _email;
  bool _acceptLoading = false;
  bool _declineLoading = false;

  @override
  void initState() {
    super.initState();
    final uri = Uri.base;
    _invitationToken = uri.queryParameters['token'] ?? '';
    _email = uri.queryParameters['email'] ?? '';
  }

  Future<void> _acceptInvitation() async {
    if (_invitationToken.isEmpty || _email.isEmpty) {
      WpSnackbar.error(
        'Invalid Link',
        'Missing token or email in the invitation URL.',
      );
      return;
    }

    setState(() => _acceptLoading = true);
    try {
      final response = await WpApi.parentInvitationAccept(
        invitationToken: _invitationToken,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final detail = messageFromApiBody(response.body);
        WpSnackbar.success(
          'Invitation accepted',
          detail ??
              'Check your email to set up your account password.',
        );
      } else {
        final msg = userFacingApiMessage(
          response.body,
          'We couldn’t accept this invitation. Please try again.',
        );
        WpSnackbar.error('Unable to accept invitation', msg);
      }
    } catch (e) {
      WpSnackbar.error(
        'Network Error',
        'Unable to process invitation. Please try again.',
      );
    } finally {
      setState(() => _acceptLoading = false);
    }
  }

  Future<void> _declineInvitation() async {
    if (_email.isEmpty) {
      WpSnackbar.error(
        'Invalid Link',
        'Email is required to decline invitation.',
      );
      return;
    }

    setState(() => _declineLoading = true);
    try {
      final response = await WpApi.parentDeclineInvitation(email: _email);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        WpSnackbar.success('Declined', 'Invitation declined successfully.');
        Get.offNamed(AppRoutes.decline);
      } else {
        final msg = userFacingApiMessage(
          response.body,
          'We couldn’t process your decline request. Please try again.',
        );
        WpSnackbar.error('Unable to decline invitation', msg);
      }
    } catch (_) {
      WpSnackbar.error('Network Error', 'Unable to decline invitation.');
    } finally {
      setState(() => _declineLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = _acceptLoading || _declineLoading;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE9EBEF)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Icon(Icons.person_outline, size: 50)),
                const SizedBox(height: 20),

                /// Title
                const Center(
                  child: Text(
                    "Parent Invitation",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                /// Subtitle
                const Center(
                  child: Text(
                    "Complete your parent registration",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 6),

                /// Email
                Center(
                  child: Text(
                    _email.isNotEmpty ? _email : "No email found",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 30),

                /// ✅ Accept Button
                WpButton.primary(
                  label: 'Accept & setup account',
                  isLoading: _acceptLoading,
                  onPressed: busy ? null : _acceptInvitation,
                ),

                const SizedBox(height: 12),

                /// ❌ Decline Button
                WpButton.secondary(
                  label: 'Decline',
                  isLoading: _declineLoading,
                  onPressed: busy ? null : _declineInvitation,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
