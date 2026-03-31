import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InvitationSuccessPage extends StatelessWidget {
  const InvitationSuccessPage({super.key});

  static const String _appStoreUrl =
      'https://apps.apple.com/app/your-app-id'; // 🔁 Replace

  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=your.package.name'; // 🔁 Replace

  static Future<void> _openStoreUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Success Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  size: 42,
                  color: Colors.green[600],
                ),
              ),

              const SizedBox(height: 24),

              /// Title
              const Text(
                "Account Created Successfully!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),

              const SizedBox(height: 12),

              /// Subtitle
              const Text(
                "Install our Mobile App from App Store or Play Store to login.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              ),

              const SizedBox(height: 32),

              /// App Store Button
              _storeButton(
                label: 'Download on the App Store',
                icon: Icons.apple,
                onTap: () => _openStoreUrl(_appStoreUrl),
              ),

              const SizedBox(height: 12),

              /// Play Store Button
              _storeButton(
                label: 'Get it on Google Play',
                icon: Icons.android,
                onTap: () => _openStoreUrl(_playStoreUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _storeButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1A1A1A),
          side: const BorderSide(color: Color(0xFFE9EBEF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
