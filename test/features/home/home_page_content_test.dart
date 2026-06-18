import 'package:flutter/material.dart';
import 'package:flutter_app/app/configuration/configuration.dart';
import 'package:flutter_app/app/setup/flavor.dart';
import 'package:flutter_app/app/theme/app_theme.dart';
import 'package:flutter_app/assets/app_localizations.gen.dart';
import 'package:flutter_app/features/home/home_page_content.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

Widget buildSubject() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.getThemeData(brightness: Brightness.light),
    home: const Scaffold(body: HomePageContent()),
  );
}

void main() {
  Configuration.setup(flavor: Flavor.develop);

  patrolWidgetTest(
    'HomePageContent - shows Home title',
    ($) async {
      await $.pumpWidgetAndSettle(buildSubject());

      expect(find.byKey(const Key('home_title')), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    },
  );

  patrolWidgetTest(
    'HomePageContent - shows debug tools button',
    ($) async {
      await $.pumpWidgetAndSettle(buildSubject());

      // Tap not tested here — it requires a router context
      final l10n = AppLocalizations.of($.tester.element(find.byType(HomePageContent)))!;
      expect(find.text(l10n.featureHomepageOpenDebugTools), findsOneWidget);
    },
  );
}
