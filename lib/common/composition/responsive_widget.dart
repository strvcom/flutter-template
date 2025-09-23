import 'package:flutter/material.dart';

/// This widget is a helper to build responsive UIs.
/// Feel free to polish this Widget by app needs. Some projects may require just small and large sizes.
class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    required this.small,
    super.key,
    this.medium,
    this.large,
  });

  static const double mediumSizeThreshold = 800;
  static const double largeSizeThreshold = 1600;

  final Widget Function() small;
  final Widget Function()? medium;
  final Widget Function()? large;

  @override
  Widget build(BuildContext context) {
    return resolveValue(
      context,
      small: small,
      medium: medium,
      large: large,
    );
  }

  static T resolveValue<T>(
    BuildContext context, {
    required T Function() small,
    T Function()? medium,
    T Function()? large,
  }) {
    final maxWidth = MediaQuery.sizeOf(context).width;
    return resolveValueByWidth(maxWidth, small: small, medium: medium, large: large);
  }

  static T resolveValueByWidth<T>(
    double maxWidth, {
    required T Function() small,
    T Function()? medium,
    T Function()? large,
  }) {
    try {
      if (maxWidth >= largeSizeThreshold && large != null) {
        return large();
      } else if (maxWidth >= mediumSizeThreshold && medium != null) {
        return medium();
      } else {
        return small();
      }
      // ignore: avoid_catching_errors
    } on FlutterError catch (_) {
      return small();
    }
  }

  static BoxConstraints getSuggestedConstraints(BuildContext context) {
    return BoxConstraints(
      maxWidth: ResponsiveWidget.resolveValue(
        context,
        small: () => double.infinity,
        medium: () => ResponsiveWidget.mediumSizeThreshold,
        large: () => ResponsiveWidget.largeSizeThreshold,
      ),
    );
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width < mediumSizeThreshold;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= mediumSizeThreshold && MediaQuery.sizeOf(context).width < largeSizeThreshold;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= largeSizeThreshold;
  }
}
