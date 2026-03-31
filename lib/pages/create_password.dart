import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texans_web/controllers/invitation_controller.dart';
import 'package:texans_web/pages/decline_screen.dart';
import 'package:texans_web/pages/success_screen.dart';
import 'package:texans_web/theme/wp_snackbar.dart';
import 'package:texans_web/widgets/wp_button.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  late final InvitationController _controller;

  @override
  void initState() {
    super.initState();
    final uri = Uri.base;
    _controller = Get.put(
      InvitationController(
        email: uri.queryParameters['email'] ?? '',
        otp: uri.queryParameters['otp'] ?? '',
        action: uri.queryParameters['action'] ?? 'set',
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isAnyLoading =
          _controller.isAcceptLoading.value ||
          _controller.isDeclineLoading.value;

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
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// Email
                      Center(
                        child: Text(
                          _controller.email.value.isNotEmpty
                              ? _controller.email.value
                              : "No email found",
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

                      /// ✅ Accept Button
                      WpButton.primary(
                        label: 'Create Account',
                        isLoading: _controller.isAcceptLoading.value,
                        onPressed: isAnyLoading ? null : _handleCreateAccount,
                      ),

                      const SizedBox(height: 12),

                      /// ❌ Decline Button
                      WpButton.secondary(
                        label: 'Decline Invitation',
                        isLoading: _controller.isDeclineLoading.value,
                        onPressed: isAnyLoading
                            ? null
                            : _handleDeclineInvitation,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
    });
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

  Future<void> _handleCreateAccount() async {
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (password.isEmpty) return _showError("Please enter a password");
    if (password.length < 6) {
      return _showError("Password must be at least 6 characters");
    }
    if (confirm.isEmpty) return _showError("Please confirm your password");
    if (password != confirm) return _showError("Passwords do not match");

    final success = await _controller.acceptInvitation(
      password: password,
      confirmPassword: confirm,
    );

    if (success) {
      Get.off(() => const InvitationSuccessPage());
    }
  }

  Future<void> _handleDeclineInvitation() async {
    final confirmed = await _showDeclineConfirmDialog();
    if (!confirmed) return;

    final success = await _controller.declineInvitation();
    if (success) {
      Get.off(() => const InvitationDeclinePage());
    }
  }

  Future<bool> _showDeclineConfirmDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Decline Invitation"),
            content: const Text(
              "Are you sure you want to decline this invitation?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  "Decline",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showError(String message) {
    WpSnackbar.error('Error', message);
  }
}
