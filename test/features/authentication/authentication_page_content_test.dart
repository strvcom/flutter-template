import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/configuration/configuration.dart';
import 'package:flutter_app/app/setup/flavor.dart';
import 'package:flutter_app/app/theme/app_theme.dart';
import 'package:flutter_app/assets/app_localizations.gen.dart';
import 'package:flutter_app/features/authentication/authentication_page_content.dart';
import 'package:flutter_app/features/authentication/authentication_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.getThemeData(brightness: Brightness.light),
    home: Scaffold(body: child),
  );
}

class _StubAuthNotifier extends AuthenticationStateNotifier {
  _StubAuthNotifier(this._stub);

  final AuthenticationState _stub;

  @override
  FutureOr<AuthenticationState> build() async => _stub;
}

void main() {
  Configuration.setup(flavor: Flavor.develop);

  patrolWidgetTest(
    'AuthenticationPageContent - shows all sign-in buttons',
    ($) async {
      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            authenticationStateProvider.overrideWith(
              () => _StubAuthNotifier(
                const AuthenticationState(isGoogleSigningIn: false, isAppleSigningIn: false),
              ),
            ),
          ],
          child: _wrap(const AuthenticationPageContent()),
        ),
      );

      expect(find.text('Mock Sign In'), findsOneWidget);
      expect(find.text('Sign in Anonymously'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.text('Sign in with Apple'), findsOneWidget);
    },
  );

  patrolWidgetTest(
    'AuthenticationPageContent - Apple button visible while Google is loading',
    ($) async {
      // pumpWidgetAndSettle would time out because isGoogleSigningIn=true keeps
      // the loading spinner animating indefinitely — use a single pump instead.
      await $.tester.pumpWidget(
        ProviderScope(
          overrides: [
            authenticationStateProvider.overrideWith(
              () => _StubAuthNotifier(
                const AuthenticationState(isGoogleSigningIn: true, isAppleSigningIn: false),
              ),
            ),
          ],
          child: _wrap(const AuthenticationPageContent()),
        ),
      );
      await $.tester.pump();

      expect(find.text('Sign in with Apple'), findsOneWidget);
    },
  );
}
