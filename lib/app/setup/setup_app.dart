import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/app.dart';
import 'package:flutter_app/app/configuration/configuration.dart';
import 'package:flutter_app/app/setup/app_platform.dart';
import 'package:flutter_app/app/setup/flavor.dart';
import 'package:flutter_app/app/setup/web_setup.dart';
import 'package:flutter_app/app/theme/custom_system_bars_theme.dart';
import 'package:flutter_app/common/provider/firebase_messaging_service.dart';
import 'package:flutter_app/common/provider/firebase_remote_config_service.dart';
import 'package:flutter_app/common/provider/notifications_service.dart';
import 'package:flutter_app/common/provider/theme_mode_provider.dart';
import 'package:flutter_app/core/analytics/crashlytics_manager.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:freerasp/freerasp.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:window_manager/window_manager.dart';

Future<void> setupApp({required Flavor flavor}) async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }

  // Force app orientation to portrait and landscape.
  // This must be also forced in info.plist file for iOS, under [UISupportedInterfaceOrientations].
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Configure Flavor
  await Configuration.setup(flavor: flavor);

  // Setup Firebase
  await _setupFirebase(flavor: flavor);
  await _setupFirebaseCrashlytics();
  await _setupFirebaseRemoteConfig();
  await _setupFirebaseMessaging();
  await _setupLocalNotificationsService();

  // Setup Google Sign In
  await GoogleSignIn.instance.initialize();

  // Setup FreeRASP Security
  await _setupRASP(flavor: flavor);

  // Web support
  await _setupWebPlatform(flavor: flavor);

  // Desktop support
  await _setupDesktopPlatform();

  // Setup Images Cache size
  PaintingBinding.instance.imageCache.maximumSize = 100; // Number of images to hold in cache
  PaintingBinding.instance.imageCache.maximumSizeBytes = 200 << 20; // Equals to 250MB of cache

  // Load Theme Mode from DB before starting app
  await providerContainer.read(themeModeNotifierProvider.future);

  // Setup reactive Edge-to-Edge support across all platforms
  await CustomSystemBarsTheme.setupSystemBarsTheme(providerContainer: providerContainer);
}

// TODO: Support it or remove it!
Future<void> _setupFirebase({required Flavor flavor}) async {
  if (AppPlatform.isMobile || AppPlatform.isMacOS) {
    await Firebase.initializeApp();
  } else if (AppPlatform.isWeb) {
    await Firebase.initializeApp(
      // For WebApp we need to specify the FirebaseOptions here!
      // TODO: Replace with actual values. Can be found inside Firebase -> Project Settings, under Web App
      options: const FirebaseOptions(
        apiKey: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
        authDomain: 'strv-flutter-template.firebaseapp.com',
        projectId: 'strv-flutter-template',
        storageBucket: 'strv-flutter-template.appspot.com',
        messagingSenderId: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
        appId: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
        measurementId: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
      ),
    );
  }
}

/// TODO: Support it or remove it!
/// Setup Firebase crashlytics according [docs](https://firebase.google.com/docs/crashlytics/customize-crash-reports?platform=flutter).
Future<void> _setupFirebaseCrashlytics() async {
  if (!AppPlatform.isMobile) return;

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);

  // Handles errors thrown by Flutter framework and records them as fatal errors
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Handles async errors that can't be handled by Flutter framework
  PlatformDispatcher.instance.onError = (error, stack) {
    CrashlyticsManager.logCritical(
      error,
      stack: stack,
    );
    return true;
  };

  // Handles errors that happen outside of the Flutter context
  Isolate.current.addErrorListener(
    RawReceivePort((dynamic pair) async {
      if (pair is List && pair.length == 2 && pair[1] is StackTrace) {
        final dynamic error = pair[0];
        final stack = pair[1] as StackTrace;

        await CrashlyticsManager.logCritical(error, stack: stack);
      } else {
        // Optionally log or handle unexpected message format
        Flogger.e('Unexpected error message format from isolate: $pair');
      }
    }).sendPort,
  );
}

/// TODO: Support it or remove it!
Future<void> _setupFirebaseRemoteConfig() async {
  if (!AppPlatform.isMobile) return;

  await providerContainer.read(firebaseRemoteConfigServiceProvider.future);
}

/// TODO: Support it or remove it!
Future<void> _setupFirebaseMessaging() async {
  if (!AppPlatform.isLinux && !AppPlatform.isWindows) {
    await providerContainer.read(firebaseMessagingServiceProvider.future);
  }
}

/// TODO: Support it or remove it!
Future<void> _setupLocalNotificationsService() async {
  if (!AppPlatform.isLinux && !AppPlatform.isWindows) {
    await providerContainer.read(notificationsServiceProvider.future);
  }
}

// TODO: [FreeRASP] Configure correct package names and other values
Future<void> _setupRASP({required Flavor flavor}) async {
  // Only Mobile platforms are supported!
  if (!AppPlatform.isMobile) return;

  final config = TalsecConfig(
    isProd: flavor == Flavor.production && !kDebugMode,
    watcherMail: 'lukas.hermann@strv.com',

    /// For Android
    androidConfig: AndroidConfig(
      packageName: 'com.strv.flutter.template',
      // signingCertHashes: list of hashes of the certificates of the keys which were used to sign the application.
      // At least one hash value must be provided. Hashes which are passed here must be encoded in Base64 form
      // https://github.com/talsec/Free-RASP-Community/wiki/Getting-your-signing-certificate-hash-of-app
      signingCertHashes: [
        '8t1mXm/GqPmhtbVWyeOlXKwa4Oe8l5v3YliMlR81VeM=', // Debug
        '0ckwAjw2ivS03BBRWhR1vBD2bqUYUGXl6brlixsmk8g=', // Release
      ],
    ),

    /// For iOS
    iosConfig: IOSConfig(
      bundleIds: ['com.strv.flutter.template'],
      teamId: 'M8AK35...',
    ),
  );

  // Setting up callbacks
  final callback = ThreatCallback(
    onAppIntegrity: () => CrashlyticsManager.logNonCritical('App integrity'),
    onObfuscationIssues: () => CrashlyticsManager.logNonCritical('Obfuscation issues'),
    onDebug: () => CrashlyticsManager.logNonCritical('Debugging'),
    onDeviceBinding: () => CrashlyticsManager.logNonCritical('Device binding'),
    onDeviceID: () => CrashlyticsManager.logNonCritical('Device ID'),
    onHooks: () => CrashlyticsManager.logNonCritical('Hooks'),
    onPasscode: () => CrashlyticsManager.logNonCritical('Phone has no passcode set'),
    onPrivilegedAccess: () => CrashlyticsManager.logNonCritical('Privileged access'),
    onSecureHardwareNotAvailable: () => CrashlyticsManager.logNonCritical('Secure hardware not available'),
    onSimulator: () => CrashlyticsManager.logNonCritical('Simulator'),
    onUnofficialStore: () => CrashlyticsManager.logNonCritical('Unofficial store'),
  );

  //  Attach listener and Start freeRASP
  Talsec.instance.attachListener(callback);
  await Talsec.instance.start(config);
}

Future<void> _setupWebPlatform({required Flavor flavor}) async {
  if (AppPlatform.isWeb) {
    // Use paths without /#/
    usePathUrlStrategy();

    // Setup the Web
    WebSetup.setup(flavor: flavor);
  }
}

Future<void> _setupDesktopPlatform() async {
  if (AppPlatform.isDesktop) {
    await windowManager.ensureInitialized();
    await windowManager.setMinimumSize(const Size(400, 400));
    await windowManager.setSize(const Size(500, 950));
  }
}
