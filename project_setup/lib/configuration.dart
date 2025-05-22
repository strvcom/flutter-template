import 'package:project_setup/core/model/app_icon_variant_model.dart';
import 'package:project_setup/core/model/setup_platform.dart';

class Configuration {
  // Title: App Icon
  static final appIconBackgroundColor = '#F2F2F2';
  static final appIconVariants = [
    AppIconVariantModel(name: 'developDebug', labelColorHex: '#37B73B', labelText: 'DEV', debugIndicator: true),
    AppIconVariantModel(name: 'developRelease', labelColorHex: '#37B73B', labelText: 'DEV'),
    AppIconVariantModel(name: 'stagingDebug', labelColorHex: '#3C45D9', labelText: 'STG', debugIndicator: true),
    AppIconVariantModel(name: 'stagingRelease', labelColorHex: '#3C45D9', labelText: 'STG'),
    AppIconVariantModel(name: 'productionDebug', labelColorHex: '#68217A', labelText: 'PROD', debugIndicator: true),
    AppIconVariantModel(name: 'productionRelease', platforms: SetupPlatform.all()),
  ];

  // Title: Splash Screen
  static final splashScreenBackgroundColor = '#F2F2F2';
  static final splashScreenDarkModeBackgroundColor = '#121618';
  static final splashScreenPlatforms = [SetupPlatform.android, SetupPlatform.ios, SetupPlatform.web];

  // Title: Rename
  static final renameOldAppName = 'Flutter Template';
  static final renameNewAppName = 'Flutter Template';
  static final renameOldPackageName = 'cz.helu.flutter.template';
  static final renameNewPackageName = 'cz.helu.flutter.template';
  static final renameAppNameIncludedFiles = [
    'README.md',
    'AndroidManifest.xml',
    'Info.plist',
    'my_application.cc',
    'AppInfo.xcconfig',
    'index.html',
    'Runner.rc',
    'app_en.arb',
    'app.dart',
  ];
  static final renamePackageNameIncludedFiles = [
    'pubspec.yaml',
    'android_play_store_distribution.yml',
    'build.gradle',
    'MainActivityTest.java',
    'MainActivity.kt',
    'AndroidManifest.xml',
    'project.pbxproj',
    'CMakeLists.txt',
    'AppInfo.xcconfig',
    'setup_app.dart',
  ];
}
