import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    super.key,
    required this.small,
    this.medium,
    this.large,
  });

  static const double mediumSizeTreshold = 800;
  static const double largeSizeTreshold = 1600;

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
    if (maxWidth >= largeSizeTreshold && large != null) {
      return large();
    } else if (maxWidth >= mediumSizeTreshold && medium != null) {
      return medium();
    } else {
      return small();
    }
  }

  static BoxConstraints getSuggestedConstraints(BuildContext context) {
    return BoxConstraints(
      maxWidth: ResponsiveWidget.resolveValue(
        context,
        small: () => double.infinity,
        medium: () => ResponsiveWidget.mediumSizeTreshold,
        large: () => ResponsiveWidget.largeSizeTreshold,
      ),
    );
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width < mediumSizeTreshold;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= mediumSizeTreshold && MediaQuery.sizeOf(context).width < largeSizeTreshold;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= largeSizeTreshold;
  }
}
