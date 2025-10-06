import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/composition/dialog/custom_dialog.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:permission_handler/permission_handler.dart';

/// Dialog for notifying users when notification permissions are denied.
/// Provides options to open app settings or cancel the request.
///
/// Returns `true` if the user selected the positive action (Grant Access),
/// `false` if the user selected the neutral action (Cancel) or dismissed the dialog.
class CustomNotificationPermissionDeniedDialog {
  static Future<bool> show(BuildContext context) async =>
      await CustomDialog.alert(
        context: context,
        title: context.locale.notificationsPermissionDeniedDialogTitle,
        message: context.locale.notificationsPermissionDeniedDialogText,
        positiveActionTitle: context.locale.notificationsPermissionDeniedDialogPositiveAction,
        positiveAction: openAppSettings,
        neutralActionTitle: context.locale.notificationsPermissionDeniedDialogNeutralAction,
      ).show() ??
      false;
}
