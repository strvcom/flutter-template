import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/setup/app_platform.dart';
import 'package:flutter_app/common/extension/build_context.dart';

/// Creating correct indicator is little bit tricky.
/// We have to consider two variants of the indicator. Both of them have their own issues.
/// Because of that we are not using CircularProgressIndicator.adaptive.
class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    super.key,
    this.color,
    this.size = 40,
    this.iosIndicatorScalingFactor = 2,
    this.materialStrokeWidth,
  });

  final Color? color;
  final double size;
  final double iosIndicatorScalingFactor;
  final double? materialStrokeWidth;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? context.colorScheme.onSurface;

    return LayoutBuilder(builder: (context, constraints) {
      double realSize = size;
      if (constraints.maxHeight < realSize && constraints.maxHeight > 0) realSize = constraints.maxHeight;
      if (constraints.maxWidth < realSize && constraints.maxWidth > 0) realSize = constraints.maxWidth;

      if (AppPlatform.isApple) {
        /// For the iOS, the issue is that the indicator does not scale at all. We can handle that using Transform.
        return CupertinoActivityIndicator(
          radius: realSize / 2 / iosIndicatorScalingFactor,
          color: color,
        );
      } else {
        /// For Material indicator, the issue is that it is overlapping it parent by the half size of it stroke width.
        /// Sadly to size it properly, we need to double wrap it in SizedBox.
        /// Another issue is the scaling of the widget when we won't set the size. Because of that we need to wrap it inside LayoutBuilder.

        double? strokeWidth = materialStrokeWidth;
        if (strokeWidth == null) {
          if (realSize < 16) {
            strokeWidth = 1;
          } else if (realSize < 24) {
            strokeWidth = 2;
          } else if (realSize < 36) {
            strokeWidth = 3;
          } else {
            strokeWidth = 4;
          }
        }

        return SizedBox(
          width: realSize,
          height: realSize,
          child: Center(
            child: SizedBox(
              width: realSize - strokeWidth,
              height: realSize - strokeWidth,
              child: CircularProgressIndicator(
                strokeWidth: strokeWidth,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
        );
      }
    });
  }
}
