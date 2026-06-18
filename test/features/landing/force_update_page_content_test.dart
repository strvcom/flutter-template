import 'package:flutter/material.dart';
import 'package:flutter_app/app/configuration/configuration.dart';
import 'package:flutter_app/app/setup/flavor.dart';
import 'package:flutter_app/app/theme/app_theme.dart';
import 'package:flutter_app/assets/app_localizations.gen.dart';
import 'package:flutter_app/features/landing/force_update_page_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

Widget buildSubject() {
  return ProviderScope(
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.getThemeData(brightness: Brightness.light),
      home: const Scaffold(body: ForceUpdatePageContent()),
    ),
  );
}

void main() {
  Configuration.setup(flavor: Flavor.develop);

  patrolWidgetTest(
    'ForceUpdatePageContent - shows title and description',
    ($) async {
      await $.pumpWidgetAndSettle(buildSubject());

      final l10n = AppLocalizations.of($.tester.element(find.byType(ForceUpdatePageContent)))!;
      expect(find.text(l10n.forceUpdateTitle), findsOneWidget);
      expect(find.text(l10n.forceUpdateDescription), findsOneWidget);
    },
  );
}
