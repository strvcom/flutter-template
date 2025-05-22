import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/app/configuration/develop/config_develop.dart';
import 'package:flutter_app/app/configuration/production/config_production.dart';
import 'package:flutter_app/app/configuration/staging/config_staging.dart';
import 'package:flutter_app/app/setup/app_platform.dart';
import 'package:flutter_app/app/setup/flavor.dart';

class Configuration {
  Configuration({
    required this.flavor,
    required this.currentPlatform,
    this.androidDeviceInfo,
    this.iosDeviceInfo,
  });

  static Configuration? _instance;

  static Configuration get instance {
    if (_instance == null) {
      throw Exception('Configuration not set. You need to call `setup` before using it.');
    }
    return _instance!;
  }

  final Flavor flavor;
  final AppPlatform currentPlatform;
  final AndroidDeviceInfo? androidDeviceInfo;
  final IosDeviceInfo? iosDeviceInfo;

  String get apiHostUrl => switch (flavor) {
    Flavor.develop => ConfigDevelop.apiHostUrl,
    Flavor.staging => ConfigStaging.apiHostUrl,
    Flavor.production => ConfigProduction.apiHostUrl,
  };

  // Used for Web notifications
  String get vapidKey => switch (flavor) {
    Flavor.develop => ConfigDevelop.vapidKey,
    Flavor.staging => ConfigStaging.vapidKey,
    Flavor.production => ConfigProduction.vapidKey,
  };

  // Used for example for Google SignIn init
  String? get firebaseClientID => switch (flavor) {
    Flavor.develop => switch (currentPlatform) {
      AppPlatform.android => ConfigDevelop.androidClientId,
      AppPlatform.iOS => ConfigDevelop.iosClientId,
      AppPlatform.web => ConfigDevelop.webClientId,
      _ => null,
    },
    Flavor.staging => switch (currentPlatform) {
      AppPlatform.android => ConfigStaging.androidClientId,
      AppPlatform.iOS => ConfigStaging.iosClientId,
      AppPlatform.web => ConfigStaging.webClientId,
      _ => null,
    },
    Flavor.production => switch (currentPlatform) {
      AppPlatform.android => ConfigProduction.androidClientId,
      AppPlatform.iOS => ConfigProduction.iosClientId,
      AppPlatform.web => ConfigProduction.webClientId,
      _ => null,
    },
  };

  // Function which setups base configuration.
  static Future<void> setup({required Flavor flavor}) async {
    AppPlatform currentPlatform;
    AndroidDeviceInfo? androidInfo;
    IosDeviceInfo? iosDeviceInfo;

    if (kIsWeb) {
      currentPlatform = AppPlatform.web;
    } else if (Platform.isAndroid) {
      currentPlatform = AppPlatform.android;
      androidInfo = await DeviceInfoPlugin().androidInfo;
    } else if (Platform.isIOS) {
      currentPlatform = AppPlatform.iOS;
      iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
    } else if (Platform.isMacOS) {
      currentPlatform = AppPlatform.macos;
    } else if (Platform.isLinux) {
      currentPlatform = AppPlatform.linux;
    } else if (Platform.isWindows) {
      currentPlatform = AppPlatform.windows;
    } else {
      throw Exception('Not supported app platform');
    }

    _instance = Configuration(
      flavor: flavor,
      currentPlatform: currentPlatform,
      androidDeviceInfo: androidInfo,
      iosDeviceInfo: iosDeviceInfo,
    );
  }
}
