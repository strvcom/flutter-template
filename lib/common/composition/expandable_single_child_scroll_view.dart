import 'package:flutter/material.dart';

/// Widget, where content can spread as much as it can (you can use `Expanded` or `Spacer`),
/// but when child doesn't fit, it will automatically become scrollable widget.
class ExpandableSingleChildScrollView extends StatelessWidget {
  const ExpandableSingleChildScrollView({
    required this.child,
    this.padding = EdgeInsets.zero,
    this.alwaysScrollablePhysics = false,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final bool alwaysScrollablePhysics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          physics: (alwaysScrollablePhysics) ? const AlwaysScrollableScrollPhysics() : null,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: Padding(
              padding: padding,
              child: IntrinsicHeight(child: child),
            ),
          ),
        );
      },
    );
  }
}
