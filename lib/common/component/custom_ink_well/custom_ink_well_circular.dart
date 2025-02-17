import 'package:flutter/material.dart';

class CustomInkWellCircular extends StatelessWidget {
  const CustomInkWellCircular({
    super.key,
    required this.onClick,
    this.onLongClick,
    this.padding,
    required this.child,
  });

  final Function()? onClick;
  final Function()? onLongClick;
  final EdgeInsets? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.all(0),
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
