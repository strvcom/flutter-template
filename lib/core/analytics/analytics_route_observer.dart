import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/analytics/analytics_manager.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_route_observer.g.dart';

@riverpod
AnalyticsRouteObserver analyticsRouteObserver(Ref ref) => AnalyticsRouteObserver(ref: ref);

class AnalyticsRouteObserver extends AutoRouterObserver {
  AnalyticsRouteObserver({required this.ref});

  final Ref ref;

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings.name == null) return;

    Flogger.d('[AnalyticsRouteObserver] New route pushed: ${route.settings.name}');
    _logScreenName(route.settings.name!);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    Flogger.d('[AnalyticsRouteObserver] Tab route visited: ${route.name}');
    _logScreenName(route.routeInfo.name);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    Flogger.d('[AnalyticsRouteObserver] Tab route re-visited: ${route.name}');
    _logScreenName(route.routeInfo.name);
  }

  void _logScreenName(String screenName) {
    try {
      ref.read(analyticsManagerLogScreenViewProvider(screenName).future);
    } on Exception catch (error) {
      Flogger.e('[AnalyticsRouteObserver] Error while sending event $error');
    }
  }
}
