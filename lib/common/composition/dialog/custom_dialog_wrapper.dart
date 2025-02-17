import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/setup/app_platform.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class CustomDialogWrapper extends StatelessWidget {
  const CustomDialogWrapper.alert({
    super.key,
    required this.context,
    required this.title,
    this.message,
    this.positiveActionTitle,
    this.positiveAction,
    this.neutralActionTitle,
    this.neutralAction,
    this.negativeActionTitle,
    this.negativeAction,
    this.automaticallyCloseOnAction = true,
    this.forceMaterial = false,
  }) : content = null;

  const CustomDialogWrapper.custom({
    super.key,
    required this.context,
    required this.title,
    this.content,
    this.positiveActionTitle,
    this.positiveAction,
    this.neutralActionTitle,
    this.neutralAction,
    this.negativeActionTitle,
    this.negativeAction,
    this.automaticallyCloseOnAction = true,
    this.forceMaterial = false,
  }) : message = null;

  final BuildContext context;
  final String title;
  final String? message;
  final Widget? content;
  final String? positiveActionTitle;
  final VoidCallback? positiveAction;
  final String? neutralActionTitle;
  final VoidCallback? neutralAction;
  final String? negativeActionTitle;
  final VoidCallback? negativeAction;
  final bool automaticallyCloseOnAction;
  final bool forceMaterial;

  @override
  Widget build(BuildContext context) {
    if (AppPlatform.isIOS && content == null && !forceMaterial) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: message != null ? SingleChildScrollView(child: Text(message!)) : const SizedBox(),
        actions: [
          if (neutralActionTitle != null)
            CupertinoDialogAction(
              onPressed: () => _neutralButtonAction(context),
              textStyle: const TextStyle(color: CupertinoColors.systemBlue),
              child: Text(neutralActionTitle!),
            ),
          if (negativeActionTitle != null)
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => _negativeButtonAction(context),
              textStyle: const TextStyle(color: CupertinoColors.systemRed),
              child: Text(negativeActionTitle!),
            ),
          if (positiveActionTitle != null)
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => _positiveButtonAction(context),
              textStyle: const TextStyle(color: CupertinoColors.systemBlue),
              child: Text(positiveActionTitle!),
            ),
        ],
      );
    } else {
      return AlertDialog(
        title: CustomText(text: title, style: context.textTheme.titleLarge),
        content: content ??
            (message != null
                ? SingleChildScrollView(
                    child: CustomText(text: message!, style: context.textTheme.bodyMedium),
                  )
                : null),
        backgroundColor: context.colorScheme.surface,
        surfaceTintColor: context.colorScheme.surface, // Needs to be the same as backgroundColor
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        titlePadding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 12),
        contentPadding: const EdgeInsets.only(left: 20, right: 20),
        actionsPadding: const EdgeInsets.all(12),
        actions: [
          if (neutralActionTitle != null)
            TextButton(
              onPressed: () => _neutralButtonAction(context),
              style: TextButton.styleFrom(
                foregroundColor: context.colorScheme.primary,
              ),
              child: CustomText(text: neutralActionTitle!, style: context.textTheme.labelLarge),
            ),
          if (negativeActionTitle != null)
            TextButton(
              onPressed: () => _negativeButtonAction(context),
              style: TextButton.styleFrom(
                foregroundColor: context.colorScheme.error,
              ),
              child: CustomText(text: negativeActionTitle!, style: context.textTheme.labelLarge, color: context.colorScheme.error),
            ),
          if (positiveActionTitle != null)
            TextButton(
              onPressed: () => _positiveButtonAction(context),
              style: TextButton.styleFrom(
                foregroundColor: context.colorScheme.primary,
              ),
              child: CustomText(text: positiveActionTitle!, style: context.textTheme.labelLarge),
            ),
        ],
      );
    }
  }

  void _positiveButtonAction(BuildContext context) {
    positiveAction?.call();
    if (automaticallyCloseOnAction) {
      closeDialog(context: context, result: true);
    }
  }

  void _neutralButtonAction(BuildContext context) {
    neutralAction?.call();
    if (automaticallyCloseOnAction) {
      closeDialog(context: context, result: false);
    }
  }

  void _negativeButtonAction(BuildContext context) {
    negativeAction?.call();
    if (automaticallyCloseOnAction) {
      closeDialog(context: context, result: true);
    }
  }

  void closeDialog({required BuildContext context, required bool result}) {
    Navigator.of(context).pop(result);
  }
}
