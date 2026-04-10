import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texans_web/api/wp_api.dart';
import 'package:texans_web/routes/app_routes.dart';
import 'package:texans_web/theme/wp_snackbar.dart';
import 'package:texans_web/utils/api_response_message.dart';
import 'package:texans_web/utils/password_validation.dart';
import 'package:texans_web/widgets/wp_button.dart';

class ParentCreatePasswordPage extends StatefulWidget {
  const ParentCreatePasswordPage({super.key});

  @override
  State<ParentCreatePasswordPage> createState() =>
      _ParentCreatePasswordPageState();
}

class _ParentCreatePasswordPageState extends State<ParentCreatePasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _isLoading = false;

  String _email = '';
  String _otp = '';
  String _action = '';

  @override
  void initState() {
    super.initState();
    final uri = Uri.base;
    _email = uri.queryParameters['email'] ?? '';
    _otp = uri.queryParameters['otp'] ?? '';
    _action = uri.queryParameters['action']?.trim().isNotEmpty == true
        ? uri.queryParameters['action']!
        : 'set';
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateAccount() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (_email.isEmpty) {
      WpSnackbar.error(
        'Error',
        'Email is missing, please use the invitation link.',
      );
      return;
    }

    if (_otp.isEmpty) {
      WpSnackbar.error('Error', 'Please enter OTP');
      return;
    }
    if (password.isEmpty) {
      WpSnackbar.error('Error', 'Please enter password');
      return;
    }
    final policy = passwordPolicyError(password);
    if (policy != null) {
      WpSnackbar.error('Error', policy);
      return;
    }
    if (confirmPassword.isEmpty) {
      WpSnackbar.error('Error', 'Please confirm password');
      return;
    }
    if (password != confirmPassword) {
      WpSnackbar.error('Error', 'Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await WpApi.parentsetPass(
        email: _email,
        otp: _otp,
        password: password,
        confirmPassword: confirmPassword,
        action: _action,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final msg = messageFromApiBody(response.body) ??
            'Account created successfully!';
        WpSnackbar.success('Success', msg);
        Get.offAllNamed(AppRoutes.success);
      } else {
        WpSnackbar.error(
          'Error',
          userFacingApiMessage(
            response.body,
            'Could not create your account. Please try again.',
          ),
        );
      }
    } catch (_) {
      WpSnackbar.error('Network Error', 'Unable to create account.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    "Set Up Your Account",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                /// Email
                Center(
                  child: Text(
                    _email.isNotEmpty ? _email : "No email found",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 30),

                /// Password
                const Text("Password"),
                const SizedBox(height: 6),
                _passwordField(
                  controller: _passwordController,
                  hint: "Enter your password",
                  isHidden: _hidePassword,
                  onToggle: () =>
                      setState(() => _hidePassword = !_hidePassword),
                ),
                const SizedBox(height: 20),

                /// Confirm Password
                const Text("Confirm Password"),
                const SizedBox(height: 6),
                _passwordField(
                  controller: _confirmPasswordController,
                  hint: "Confirm your password",
                  isHidden: _hideConfirmPassword,
                  onToggle: () => setState(
                    () => _hideConfirmPassword = !_hideConfirmPassword,
                  ),
                ),
                const SizedBox(height: 30),

                /// ✅ Create Account Button
                WpButton.primary(
                  label: 'Create Account',
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _handleCreateAccount,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool isHidden,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: isHidden,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
