import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/app/setup/app_platform.dart';

class CrashlyticsManager {
  static Future<void> logMessage(dynamic message) async {
    if (Firebase.apps.isNotEmpty && AppPlatform.isMobile && !kDebugMode) {
      await FirebaseCrashlytics.instance.log(message.toString());
    }
  }

  static Future<void> logNonCritical(dynamic exception, {StackTrace? stack, String? message}) async {
    if (Firebase.apps.isNotEmpty && AppPlatform.isMobile && !kDebugMode) {
      await FirebaseCrashlytics.instance.recordError(exception, stack, reason: message);
    }
  }

  static Future<void> logCritical(dynamic exception, {StackTrace? stack, String? message}) async {
    if (Firebase.apps.isNotEmpty && AppPlatform.isMobile && !kDebugMode) {
      await FirebaseCrashlytics.instance.recordError(exception, stack, reason: message, fatal: true);
    }
  }
}
