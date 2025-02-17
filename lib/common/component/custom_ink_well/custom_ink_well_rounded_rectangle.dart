import 'package:flutter/material.dart';

class CustomInkWellRoundedRectangle extends StatelessWidget {
  const CustomInkWellRoundedRectangle({
    super.key,
    required this.onClick,
    this.onLongClick,
    required this.cornerRadius,
    this.padding,
    required this.child,
  });

  final Function()? onClick;
  final Function()? onLongClick;
  final double cornerRadius;
  final EdgeInsets? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.all(0),
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
