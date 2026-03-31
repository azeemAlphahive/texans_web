// wp_button.dart
import 'package:flutter/material.dart';
import 'package:texans_web/theme/wp_colors.dart';

class WpButton extends StatelessWidget {
  const WpButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.height,
    this.fontSize,
    this.borderRadius,
  }) : _variant = _WpButtonVariant.primary;

  const WpButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.height,
    this.fontSize,
    this.borderRadius,
  }) : _variant = _WpButtonVariant.secondary;

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final _WpButtonVariant _variant;

  final double? height;

  final double? fontSize;

  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = enabled && !isLoading && onPressed != null;

    // Fixed-pixel fallbacks — no screenutil
    final effectiveHeight = height ?? 44.0;
    final effectiveFontSize = fontSize ?? 14.0;
    final effectiveRadius = borderRadius ?? 10.0;

    final bg = _variant == _WpButtonVariant.primary
        ? WpColors.black
        : Colors.white;
    final fg = _variant == _WpButtonVariant.primary
        ? Colors.white
        : WpColors.textPrimary;
    final border = _variant == _WpButtonVariant.primary
        ? Colors.transparent
        : WpColors.border;

    return SizedBox(
      width: double.infinity,
      height: effectiveHeight,
      child: ElevatedButton(
        onPressed: effectiveEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: isLoading
              ? bg
              : (_variant == _WpButtonVariant.primary
                  ? WpColors.black
                  : Colors.white),
          disabledForegroundColor: isLoading ? fg : fg.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveRadius),
            side: BorderSide(color: border),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(fg),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: effectiveFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

enum _WpButtonVariant { primary, secondary }
