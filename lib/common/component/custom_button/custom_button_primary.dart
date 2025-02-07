import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/component/custom_progress_indicator.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class CustomButtonPrimary extends StatelessWidget {
  const CustomButtonPrimary({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (isLoading || !isEnabled)
          ? null
          : () {
              // Add touch feedback to buttons
              HapticFeedback.mediumImpact();
              onPressed();
            },
      style: _getButtonStyle(context),
      child: (isLoading)
          ? SizedBox(
              width: 24,
              height: 24,
              child: CustomProgressIndicator(color: context.colorScheme.onPrimary),
            )
          : CustomText(
              text: text,
              style: context.textTheme.titleMedium.copyWith(letterSpacing: 0.2, color: context.colorScheme.onPrimary),
              textAlign: TextAlign.center,
            ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(context.colorScheme.primary),
      foregroundColor: WidgetStateProperty.all(context.colorScheme.onPrimary),
      overlayColor: WidgetStateProperty.all(context.colorScheme.secondary.withValues(alpha: 0.1)),
      surfaceTintColor: WidgetStateProperty.all(context.colorScheme.primary),
      shadowColor: WidgetStateProperty.all(context.colorScheme.shadow),
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
      minimumSize: WidgetStateProperty.all(const Size.fromHeight(56)),
      elevation: WidgetStateProperty.all(3),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
