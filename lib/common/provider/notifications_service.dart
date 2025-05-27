import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app/common/data/model/notification_payload_model.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_service.g.dart';

@Riverpod(keepAlive: true)
class NotificationsService extends _$NotificationsService {
  static final _flutterLocalNotifications = FlutterLocalNotificationsPlugin();

  /// Check whether user has at least any Notification permission allowed
  static Future<bool> isPermissionGranted() async {
    final permissionStatus = await Permission.notification.status;
    return !permissionStatus.isDenied && !permissionStatus.isPermanentlyDenied;
  }

  /// Check whether user has at least any Notification permission denied
  static Future<bool> isPermissionPermanentlyDenied() async => Permission.notification.isPermanentlyDenied;

  /// Request Notification permission from the user
  /// Returns true if the permission was granted, false if it was denied or permanently denied.
  /// Warning: If the permission is permanently denied, this method will automatically
  /// open the app settings. Consider showing a dialog to the user first.
  static Future<bool> requestPermission() async {
    var permissionStatus = await Permission.notification.status;

    // If the status is denied, we request it.
    // This means that the request has not been displayed yet, or displayed only once on Android.
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await Permission.notification.request();
      return !permissionStatus.isDenied && !permissionStatus.isPermanentlyDenied;
    }
    // If the status is permanentlyDenied, we cannot request it again. We can only open the appSettings.
    else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
      return false;
    }

    // Otherwise, we handle the status as granted.
    return true;
  }

  /// The backgroundHandler needs to be either a static function or a top level function to be accessible as a Flutter entry point
  @pragma('vm:entry-point')
  static void localNotificationOpenBgHandler(NotificationResponse notificationResponse) {
    Flogger.i('[Notifications] onLocalNotificationOpenedBgHandler ${notificationResponse.payload}');
    _tryOpeningNotificationFromPayload(notificationResponse.payload);
  }

  static void handleNotificationOpen(NotificationPayloadModel notificationModel) {
    switch (notificationModel) {
      case NotificationPayloadModelSample():
        Flogger.d('[Notifications] Handle open of Sample notification');
      // TODO(HELU): [Notifications] Handle Notification open action here

      case NotificationPayloadModelUnknown():
      // Do nothing
    }
  }

  static Future<void> handleAppOpenNotification() async {
    // Title: 1. Check FirebaseMessaging for initial Message
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (await tryOpeningNotificationFromRemoteMessage(initialMessage)) return;

    // Title: 2. Check FlutterLocalNotifications for initial Message
    final notificationAppLaunchDetails = await _flutterLocalNotifications.getNotificationAppLaunchDetails();
    await _tryOpeningNotificationFromPayload(notificationAppLaunchDetails?.notificationResponse?.payload);
  }

  static Future<void> showNotification(NotificationPayloadModel notification) async {
    if (notification is NotificationPayloadModelUnknown) return;

    Flogger.i('[Notifications] New local notification to display: $notification');
    await _flutterLocalNotifications.cancelAll();
    await _flutterLocalNotifications.show(
      notification.id,
      notification.title,
      notification.body,
      defaultNotificationDetails,
      payload: jsonEncode(notification),
    );
  }

  static Future<bool> _tryOpeningNotificationFromPayload(String? payload) async {
    if (payload == null) {
      return Future.value(false);
    }

    try {
      handleNotificationOpen(NotificationPayloadModel.fromJson(jsonDecode(payload) as Map<String, dynamic>));
      return Future.value(true);
    } on Exception catch (e) {
      Flogger.e('[Notifications] Could not parse payload from notification: $payload with error $e');
    }
    return Future.value(false);
  }

  static Future<bool> tryOpeningNotificationFromRemoteMessage(RemoteMessage? message) async {
    if (message == null) {
      return Future.value(false);
    }

    try {
      handleNotificationOpen(NotificationPayloadModel.fromJson(message.data));
      return Future.value(true);
    } on Exception catch (e) {
      Flogger.e('[Notifications] Could not parse payload from notification: ${message.data} with error $e');
    }
    return Future.value(false);
  }

  @override
  FutureOr<NotificationsService> build() async {
    await _setupLocalNotifications();
    return this;
  }

  Future<void> _setupLocalNotifications() async {
    const initializationSettings = InitializationSettings(
      // This icon must be inside Android native resources
      android: AndroidInitializationSettings('notification_icon'),
      // This makes sure that we can manually request permission later
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _flutterLocalNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: localNotificationOpenBgHandler,
      onDidReceiveBackgroundNotificationResponse: localNotificationOpenBgHandler,
    );
  }
}

const defaultNotificationDetails = NotificationDetails(
  android: AndroidNotificationDetails(
    '0',
    'Default',
    channelDescription: 'Default app notifications',
    importance: Importance.max,
    priority: Priority.high,
  ),
  iOS: DarwinNotificationDetails(
    presentAlert: true,
    presentSound: true,
    presentBadge: true,
    threadIdentifier: 'Default app notifications',
  ),
);
