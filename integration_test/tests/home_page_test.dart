import 'package:flutter/widgets.dart';
import 'package:flutter_app/app/app.dart';
import 'package:flutter_app/app/setup/flavor.dart';
import 'package:flutter_app/app/setup/setup_app.dart';
import 'package:flutter_app/common/component/custom_button/custom_button_primary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'Home Page has Home title',
    ($) async {
      // We need to save and restore onError handler after setupApp, as it is overriden by the Crashlytics.
      final originalOnError = FlutterError.onError!;
      // Title: Start the app
      await setupApp(flavor: Flavor.develop);
      FlutterError.onError = originalOnError;

      await $.pumpWidgetAndSettle(
        UncontrolledProviderScope(
          container: providerContainer,
          child: const App(),
        ),
      );

      // Subtitle: Test that there is Home title text
      // Because of animation set on the widget
      expect($(#home_title), findsOneWidget);
      expect($(#home_title).$(Text).text, 'Home');

      // Subtitle: Test that there is Open Debug tools button
      expect($(CustomButtonPrimary).$(Text).text, 'Open debug tools');
    },
  );
}
