import 'package:flutter/material.dart';
import 'package:flutter_app/common/composition/dialog/custom_dialog_wrapper.dart';

class CustomAlertDialog {
  CustomAlertDialog({
    required this.context,
    required this.title,
    this.message,
    this.positiveActionTitle,
    this.positiveAction,
    this.neutralActionTitle,
    this.neutralAction,
    this.negativeActionTitle,
    this.negativeAction,
  });

  final BuildContext context;
  final String title;
  final String? message;
  final String? positiveActionTitle;
  final VoidCallback? positiveAction;
  final String? neutralActionTitle;
  final VoidCallback? neutralAction;
  final String? negativeActionTitle;
  final VoidCallback? negativeAction;

  Future<bool?> show() {
    return showDialog<bool>(
      context: context,
      builder: (builderContext) => CustomDialogWrapper.alert(
        context: builderContext,
        title: title,
        message: message,
        positiveActionTitle: positiveActionTitle,
        positiveAction: positiveAction,
        neutralActionTitle: neutralActionTitle,
        neutralAction: neutralAction,
        negativeActionTitle: negativeActionTitle,
        negativeAction: negativeAction,
      ),
    );
  }
}
