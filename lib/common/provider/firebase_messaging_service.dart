import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app/app/configuration/configuration.dart';
import 'package:flutter_app/app/setup/app_platform.dart';
import 'package:flutter_app/common/data/model/notification_payload_model.dart';
import 'package:flutter_app/common/provider/current_user_model_state.dart';
import 'package:flutter_app/common/provider/notifications_service.dart';
import 'package:flutter_app/common/usecase/create_device_token_use_case.dart';
import 'package:flutter_app/core/analytics/crashlytics_manager.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_messaging_service.g.dart';

@Riverpod(keepAlive: true)
class FirebaseMessagingService extends _$FirebaseMessagingService {
  @pragma('vm:entry-point')
  static Future<void> firebaseNotificationDisplayBgHandler(RemoteMessage message) async {
    Flogger.d('[Firebase Messaging] Display notification with payload: ${message.data}');
    await NotificationsService.showNotification(NotificationPayloadModel.fromJson(message.data));
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseNotificationOpenBgHandler(RemoteMessage message) async {
    Flogger.d('[Firebase Messaging] Open notification with payload: ${message.data}');
    await NotificationsService.tryOpeningNotificationFromRemoteMessage(message);
  }

  @override
  FutureOr<FirebaseMessagingService> build() async {
    await _setupFirebaseToken();
    await _setupFirebaseMessaging();
    return this;
  }

  /// Do not forget to call this after user sign in!
  /// getToken throws an error when the notification permission was not granted
  Future<void> registerFCMToken({String? fcmToken}) async {
    try {
      if (fcmToken == null) {
        fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: AppPlatform.isWeb ? Configuration.instance.vapidKey : null);
        Flogger.d("[Firebase Messaging] Registering User's FCM token: $fcmToken");
      }
    } on Exception catch (e, st) {
      Flogger.e('Firebase Messaging] Error while obtaining FCM token.', exception: e, stackTrace: st);
    }

    try {
      if (await ref.read(currentUserModelStateProvider.future) != null) {
        await ref.read(createDeviceTokenUseCaseProvider(deviceToken: fcmToken.toString()).future);
      }
    } on Exception catch (e, st) {
      Flogger.e('Firebase Messaging] Error while registering FCM token.', exception: e, stackTrace: st);
    }
  }

  Future<void> _setupFirebaseToken() async {
    /// This is a hotfix for iOS devices. GetToken returns error in case it is not set yet by the library.
    /// We need to try to get APNS Token before.
    /// https://stackoverflow.com/questions/77089496/flutter-apns-token-has-not-been-set-yet-please-ensure-the-apns-token-is-avail
    if (AppPlatform.isIOS) {
      var iosGetApnsTriesRemaining = 10;

      while ((await FirebaseMessaging.instance.getAPNSToken()) == null && iosGetApnsTriesRemaining != 0) {
        Flogger.d('[Firebase Messaging] Waiting for APNS token for 5ms!');
        iosGetApnsTriesRemaining--;
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }

      if (iosGetApnsTriesRemaining == 0) {
        await CrashlyticsManager.logNonCritical('APNS Token could not be obtained even after 50ms of waiting!');
        return;
      }
    }

    // Register current FCM token
    await registerFCMToken();

    // Set listener to register new FCM token
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) async {
          Flogger.d("[Firebase Messaging] User's FCM token refreshed: $fcmToken");
          await registerFCMToken(fcmToken: fcmToken);
        })
        .onError((Object err) {
          Flogger.e('[Firebase Messaging] Error while refreshed FCM token: $err');
        });
  }

  /// On Android - foreground, background and killed notifications are handled from the `data` payload and are manually displayed.
  /// Notification opening logic is then handled ny FlutterLocalNotifications.
  ///
  /// On iOS - foreground, background and killed notifications are displayed by the system from the `apns` payload.
  /// Notification opening logic is then set by `FirebaseMessaging.onMessageOpenedApp.listen()` for foreground and background.
  ///
  /// On Web - background notifications are displayed via `firebase-messaging-sw.js`, foreground notifications here via `onMessage`.
  /// Notification opening logic is not handled yet.
  ///
  /// Killed app notification open is handled on LandingPage.
  Future<void> _setupFirebaseMessaging() async {
    // Title: [Android and Web] Foreground notifications display
    if (AppPlatform.isAndroid || AppPlatform.isWeb) {
      FirebaseMessaging.onMessage.listen(firebaseNotificationDisplayBgHandler);
    }

    // Title: [iOS] Foreground notifications display. Background and Killed display handled by system
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    // Title: [Android] Background and Killed notifications display
    FirebaseMessaging.onBackgroundMessage(firebaseNotificationDisplayBgHandler);

    // Title: [iOS] Background and Foreground notifications open handling
    FirebaseMessaging.onMessageOpenedApp.listen(firebaseNotificationOpenBgHandler);
  }
}
