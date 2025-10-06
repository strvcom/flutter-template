import 'package:flutter/material.dart';

class CustomInkWellCircular extends StatelessWidget {
  const CustomInkWellCircular({
    required this.onClick,
    required this.child,
    super.key,
    this.onLongClick,
    this.padding,
  });

  final VoidCallback? onClick;
  final VoidCallback? onLongClick;
  final EdgeInsets? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
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
