import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/app/setup/app_platform.dart';
import 'package:flutter_app/app/setup/flavor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  String get apiHostUrl => dotenv.get('API_HOST_URL');

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
