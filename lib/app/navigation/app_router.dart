import 'package:auto_route/auto_route.dart';
import 'package:flutter_app/features/authentication/authentication_page.dart';
import 'package:flutter_app/features/debug_tools/debug_tools_page.dart';
import 'package:flutter_app/features/event_detail/event_detail_page.dart';
import 'package:flutter_app/features/events/events_page.dart';
import 'package:flutter_app/features/home/home_page.dart';
import 'package:flutter_app/features/landing/landing_page.dart';
import 'package:flutter_app/features/profile/profile_page.dart';
import 'package:flutter_app/features/root/root_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';
part 'app_router.gr.dart';

@riverpod
AppRouter appRouter(Ref ref) => AppRouter();

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    // Subtitle: Landing Route
    CustomRoute<void>(
      page: LandingRoute.page,
      initial: true,
      // We don't really need to animate landing page, because
      // it doesn't have UI, it's covered by splash screen.
      duration: Duration.zero,
    ),

    // Subtitle: Authentication Route
    AutoRoute(page: AuthenticationRoute.page),

    // Subtitle: Main Routes
    AutoRoute(
      page: RootRoute.page,
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: EventsRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
    AutoRoute(page: EventDetailRoute.page),

    // Subtitle: Debug Tools Routes
    AutoRoute(page: DebugToolsRoute.page),
  ];
}
