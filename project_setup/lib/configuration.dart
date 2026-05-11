import 'package:project_setup/core/entity/app_icon_variant_model.dart';
import 'package:project_setup/core/entity/setup_platform.dart';

class Configuration {
  // Title: App Icon
  static const appIconBackgroundColor = '#F2F2F2';
  static const appIconVariants = [
    AppIconVariantModel(name: 'developDebug', labelColorHex: '#37B73B', labelText: 'DEV', debugIndicator: true),
    AppIconVariantModel(name: 'developRelease', labelColorHex: '#37B73B', labelText: 'DEV'),
    AppIconVariantModel(name: 'stagingDebug', labelColorHex: '#3C45D9', labelText: 'STG', debugIndicator: true),
    AppIconVariantModel(name: 'stagingRelease', labelColorHex: '#3C45D9', labelText: 'STG'),
    AppIconVariantModel(name: 'productionDebug', labelColorHex: '#68217A', labelText: 'PROD', debugIndicator: true),
    AppIconVariantModel(name: 'productionRelease', platforms: SetupPlatform.values),
  ];

  // Title: Splash Screen
  static const splashScreenBackgroundColor = '#F2F2F2';
  static const splashScreenDarkModeBackgroundColor = '#121618';
  static const splashScreenPlatforms = [SetupPlatform.android, SetupPlatform.ios, SetupPlatform.web];

  // Title: Rename
  static const renameOldAppName = 'Flutter Template';
  static const renameNewAppName = 'Flutter Template';
  static const renameOldPackageName = 'com.strv.flutter.template';
  static const renameNewPackageName = 'com.strv.flutter.template';
  static const renameAppNameIncludedFiles = [
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
  static const renamePackageNameIncludedFiles = [
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
