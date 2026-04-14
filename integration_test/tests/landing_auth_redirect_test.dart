import 'package:flutter/widgets.dart';
import 'package:flutter_app/app/app.dart';
import 'package:flutter_app/app/setup/flavor.dart';
import 'package:flutter_app/app/setup/setup_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'Landing redirects unauthenticated user to authentication',
    ($) async {
      // We need to save and restore onError handler after setupApp, as it is overridden by Crashlytics.
      final originalOnError = FlutterError.onError!;

      await setupApp(flavor: Flavor.develop);
      FlutterError.onError = originalOnError;

      await $.pumpWidget(
        UncontrolledProviderScope(
          container: providerContainer,
          child: const App(),
        ),
      );

      await $('Mock Sign In').waitUntilVisible();

      expect($('Authentication'), findsWidgets);
      expect($('Mock Sign In'), findsOneWidget);
    },
  );
}
