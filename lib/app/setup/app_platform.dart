import 'package:flutter_app/app/configuration/configuration.dart';

/// List of all supported platforms.
enum AppPlatform {
  web,
  android,
  iOS,
  macos,
  linux,
  windows;

  static bool get isMobile {
    return Configuration.instance.currentPlatform == AppPlatform.android || Configuration.instance.currentPlatform == AppPlatform.iOS;
  }

  static bool get isAndroid {
    return Configuration.instance.currentPlatform == AppPlatform.android;
  }

  static bool get isIOS {
    return Configuration.instance.currentPlatform == AppPlatform.iOS;
  }

  static bool get isDesktop {
    return Configuration.instance.currentPlatform == AppPlatform.windows ||
        Configuration.instance.currentPlatform == AppPlatform.linux ||
        Configuration.instance.currentPlatform == AppPlatform.macos;
  }

  static bool get isWindows {
    return Configuration.instance.currentPlatform == AppPlatform.windows;
  }

  static bool get isLinux {
    return Configuration.instance.currentPlatform == AppPlatform.linux;
  }

  static bool get isMacOS {
    return Configuration.instance.currentPlatform == AppPlatform.macos;
  }

  static bool get isApple {
    return Configuration.instance.currentPlatform == AppPlatform.iOS || Configuration.instance.currentPlatform == AppPlatform.macos;
  }

  static bool get isWeb {
    return Configuration.instance.currentPlatform == AppPlatform.web;
  }
}
