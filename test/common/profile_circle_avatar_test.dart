import 'package:flutter_app/app/configuration/configuration.dart';
import 'package:flutter_app/app/setup/flavor.dart';
import 'package:flutter_app/common/component/custom_profile_avatar.dart';
import 'package:patrol/patrol.dart';

void main() {
  // Title: Setup app configuration
  Configuration.setup(flavor: Flavor.develop);

  patrolTest(
    'ProfileCircleAvatar - Widget test',
    ($) async {
      // Title: Inflate widget
      await $.pumpWidget(
        const CustomProfileAvatar(
          imageUrl: 'http://www.test.com/img.jpg',
          size: 56,
        ),
      );
    },
  );
}
