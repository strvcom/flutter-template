import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_progress_indicator.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.buttonSize = 44,
    this.iconSize = 24,
    this.loadingColor,
  });

  final Widget icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final double buttonSize;
  final double iconSize;
  final Color? loadingColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: isLoading
          ? Padding(
              padding: const EdgeInsets.all(4),
              child: CustomProgressIndicator(
                color: loadingColor,
              ),
            )
          : IconButton(
              padding: EdgeInsets.zero,
              onPressed: onPressed,
              icon: icon,
              iconSize: iconSize,
            ),
    );
  }
}
