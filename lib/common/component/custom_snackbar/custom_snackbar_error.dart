import 'package:flutter/material.dart';
import 'package:flutter_app/assets/assets.gen.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/composition/responsive_widget.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/core/flogger.dart';

class CustomSnackbarError {
  CustomSnackbarError({
    required this.context,
    required this.message,
    this.optionalBottomSpacing = 0,
  });

  static final List<String> _shownMessages = [];

  final BuildContext context;
  final String message;
  final double optionalBottomSpacing;

  Future<void> show() async {
    if (_shownMessages.contains(message)) {
      Flogger.i('[CustomSnackBar] Not going to show message $message, because it\'s already in `_shownMessages`.');
      return;
    }

    _shownMessages.add(message);

    final controller = ScaffoldMessenger.of(context).showSnackBar(createSnackBar());
    await controller.closed;

    _shownMessages.remove(message);
  }

  SnackBar createSnackBar() {
    final isSmallScreen = ResponsiveWidget.isSmallScreen(context);

    return SnackBar(
      width: isSmallScreen ? null : ResponsiveWidget.mediumSizeTreshold,
      margin: isSmallScreen ? EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20 + optionalBottomSpacing) : null,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      backgroundColor: context.colorScheme.snackbarBackground.withValues(alpha: 0.94),
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
      elevation: 0,
      content: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 24),
        child: Row(
          children: [
            Assets.svg.icErrorCircle.svg(height: 20, width: 20),
            const SizedBox(width: 16),
            Expanded(
              child: CustomText(
                text: message,
                style: context.textTheme.labelMedium,
                color: context.colorScheme.error,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
