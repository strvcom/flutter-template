import 'package:flutter/material.dart';
import 'package:flutter_app/core/analytics/analytics_screen_view.dart';
import 'package:flutter_app/core/analytics/has_analytics_screen_view_mixin.dart';

class AnalyticsMaterialPage<T> extends MaterialPage<T> with HasAnalyticsScreenViewMixin {
  const AnalyticsMaterialPage({
    required this.event,
    required super.child,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.allowSnapshotting = true,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  final AnalyticsScreenView event;
}
