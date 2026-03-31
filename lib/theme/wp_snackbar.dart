import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texans_web/theme/wp_colors.dart';

/// GetX snackbars aligned with [WpColors] (success = green, error = red).
class WpSnackbar {
  WpSnackbar._();

  static void success(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 10,
      duration: const Duration(seconds: 4),
      backgroundColor: WpColors.success.withOpacity(0.12),
      colorText: WpColors.success,
      icon: Icon(Icons.check_circle_outline, color: WpColors.success, size: 22),
    );
  }

  static void error(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 10,
      duration: const Duration(seconds: 5),
      backgroundColor: WpColors.danger.withOpacity(0.12),
      colorText: WpColors.danger,
      icon: Icon(Icons.error_outline, color: WpColors.danger, size: 22),
    );
  }
}
