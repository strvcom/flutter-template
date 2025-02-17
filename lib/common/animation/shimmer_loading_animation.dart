import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/common/extension/build_context.dart';

extension WidgetExtension on Widget {
  Widget shimmerLoadingAnimation(BuildContext context) {
    return animate(
      onPlay: (controller) => controller.repeat(),
    ).shimmer(
      delay: const Duration(milliseconds: 300),
      duration: const Duration(milliseconds: 500),
      padding: 0,
      color: context.colorScheme.shimmerForeground,
    );
  }
}
