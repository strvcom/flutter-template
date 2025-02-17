import 'package:flutter/material.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final Icon child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: context.colorScheme.primary,
      foregroundColor: context.colorScheme.onPrimary,
      splashColor: context.colorScheme.onPrimary.withValues(alpha: 0.1),
      child: child,
    );
  }
}
