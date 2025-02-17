import 'package:flutter/material.dart';
import 'package:flutter_app/app/configuration/configuration.dart';
import 'package:flutter_app/app/setup/flavor.dart';
import 'package:flutter_app/common/component/custom_button/custom_button_primary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  // Title: Setup app configuration
  Configuration.setup(flavor: Flavor.develop);

  patrolTest(
    'CustomElevatedButton - Primary',
    ($) async {
      // Title: Inflate widget
      await $.pumpWidgetAndSettle(
        Directionality(
          textDirection: TextDirection.rtl,
          child: CustomButtonPrimary(
            onPressed: () {},
            text: 'Sample',
          ),
        ),
      );

      // Subtitle: Check the widget
      expect($(CustomButtonPrimary).containing(Text), findsOneWidget);
      expect($(Text).text, 'Sample');
    },
  );
}
