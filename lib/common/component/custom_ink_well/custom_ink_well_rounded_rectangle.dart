import 'package:flutter/material.dart';

class CustomInkWellRoundedRectangle extends StatelessWidget {
  const CustomInkWellRoundedRectangle({
    required this.onClick,
    required this.cornerRadius,
    required this.child,
    super.key,
    this.onLongClick,
    this.padding,
  });

  final VoidCallback? onClick;
  final VoidCallback? onLongClick;
  final double cornerRadius;
  final EdgeInsets? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius)),
              onTap: onClick,
              onLongPress: onLongClick,
              child: const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}
