import 'package:flutter/material.dart';
import 'package:flutter_app/app/configuration/configuration.dart';
import 'package:flutter_app/app/navigation/app_router.dart';
import 'package:flutter_app/app/setup/app_platform.dart';
import 'package:flutter_app/app/setup/flavor.dart';
import 'package:flutter_app/app/theme/app_theme.dart';
import 'package:flutter_app/assets/app_localizations.gen.dart';
import 'package:flutter_app/common/provider/theme_mode_provider.dart';
import 'package:flutter_app/core/analytics/analytics_route_observer.dart';
import 'package:flutter_app/core/riverpod/provider_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final providerContainer = ProviderContainer(
  observers: [ProvidersLogger()],
);

class App extends ConsumerWidget {
  const App({super.key});

  static void startApp() {
    runApp(
      UncontrolledProviderScope(
        container: providerContainer,
        child: const App(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (Configuration.instance.flavor) {
      case Flavor.develop:
      case Flavor.staging:
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              _createAppWidget(ref),
              Banner(
                message: Configuration.instance.flavor == Flavor.develop ? 'DEV' : 'STG',
                location: BannerLocation.topStart,
                color: Configuration.instance.flavor == Flavor.develop ? const Color(0xFF37B73B) : const Color(0xFF3C45D9),
              ),
            ],
          ),
        );
      case Flavor.production:
        return _createAppWidget(ref);
    }
  }

  Widget _createAppWidget(WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    final themeProvider = ref.watch(themeModeNotifierProvider);

    return MaterialApp.router(
      title: 'Flutter Template',
      theme: AppTheme.getThemeData(brightness: Brightness.light),
      darkTheme: AppTheme.getThemeData(brightness: Brightness.dark),
      themeMode: themeProvider.value ?? ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter.config(
        navigatorObservers: () => [ref.read(analyticsRouteObserverProvider)],
      ),
      builder: (context, child) {
        if (AppPlatform.isWeb) {
          return Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => SelectionArea(child: child ?? const SizedBox()),
              ),
            ],
          );
        } else {
          return child ?? const SizedBox();
        }
      },
    );
  }
}
