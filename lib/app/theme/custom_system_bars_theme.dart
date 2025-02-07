import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/configuration/configuration.dart';
import 'package:flutter_app/app/setup/app_platform.dart';
import 'package:flutter_app/common/extension/brightness.dart';
import 'package:flutter_app/common/provider/theme_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// When you want to make an exception on one of the screens in the app, and have different Brightness
/// set for the screen, you have one of these two options:
///
/// 1) You are using [CustomAppBar] on the screen - It is then as simple as passing custom Brightness
/// to a [CustomAppBar] constructor.
///
/// 2) You are not using any AppBar - You then need to wrap the page Scaffold in the following widget:
///
/// CustomSystemBarsThemeWidget(
///   brightness: Brightness.dark,
///   child: Scaffold(
///     ...
///   ),
/// )
///
class CustomSystemBarsTheme {
  static Future<void> setupSystemBarsTheme({required ProviderContainer providerContainer}) async {
    final brightness = providerContainer.read(themeModeNotifierProvider.notifier).brightness;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await _setupSystemBarsUpdateCallback(providerContainer: providerContainer);
    await setSystemBarsTheme(brightness: brightness);
  }

  static Future<void> setSystemBarsTheme({required Brightness brightness}) async {
    final brightness = PlatformDispatcher.instance.platformBrightness;
    SystemChrome.setSystemUIOverlayStyle((getSystemBarsTheme(brightness: brightness)));
  }

  static SystemUiOverlayStyle getSystemBarsTheme({required Brightness brightness}) {
    if (AppPlatform.isAndroid) {
      return _getAndroidSystemBarsTheme(brightness: brightness);
    } else if (AppPlatform.isIOS) {
      return _getIosSystemBarsTheme(brightness: brightness);
    } else {
      return (((brightness).isLightMode) ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    }
  }

  static SystemUiOverlayStyle _getAndroidSystemBarsTheme({required Brightness brightness}) {
    final AndroidDeviceInfo androidInfo = Configuration.instance.androidDeviceInfo!;
    final bool canUseTransparentNavigation = androidInfo.version.sdkInt >= 29; // Enabled by default for iOS

    return SystemUiOverlayStyle(
      // StatusBar
      systemStatusBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness.inverse, // For Android

      // NavigationBar
      systemNavigationBarContrastEnforced: false,
      // systemNavigationBarDividerColor: Colors.transparent, // DO NOT set this one! It breaks nav icon color on API 30
      systemNavigationBarIconBrightness: brightness.inverse,
      systemNavigationBarColor: canUseTransparentNavigation
          ? Colors.transparent
          : brightness.isLightMode
              ? Colors.white
              : Colors.black,
    );
  }

  static SystemUiOverlayStyle _getIosSystemBarsTheme({required Brightness brightness}) {
    return SystemUiOverlayStyle(
      // StatusBar
      systemStatusBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness, // For iOS

      // NavigationBar
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: brightness,
    );
  }

  static Future<void> _setupSystemBarsUpdateCallback({required ProviderContainer providerContainer}) async {
    final originalCallback = PlatformDispatcher.instance.onPlatformBrightnessChanged;
    PlatformDispatcher.instance.onPlatformBrightnessChanged = () async {
      originalCallback?.call();
      final themeMode = await providerContainer.read(themeModeNotifierProvider.future);
      if (themeMode == ThemeMode.system) {
        setSystemBarsTheme(brightness: PlatformDispatcher.instance.platformBrightness);
      }
    };

    // HotFix for API 28, that need SystemBarsTheme applied on each app resume!
    if (AppPlatform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt == 28) {
        SystemChannels.lifecycle.setMessageHandler((msg) async {
          if (msg == AppLifecycleState.resumed.toString()) {
            final themeMode = await providerContainer.read(themeModeNotifierProvider.future);
            if (themeMode == ThemeMode.system) {
              setSystemBarsTheme(brightness: PlatformDispatcher.instance.platformBrightness);
            }
          }
          return Future.value(msg);
        });
      }
    }
  }
}

class CustomSystemBarsThemeWidget extends StatelessWidget {
  const CustomSystemBarsThemeWidget({
    super.key,
    required this.brightness,
    required this.child,
  });

  final Brightness brightness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: CustomSystemBarsTheme.getSystemBarsTheme(brightness: brightness),
      child: child,
    );
  }
}
