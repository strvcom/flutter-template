import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_button/custom_button_primary.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/composition/expandable_single_child_scroll_view.dart';
import 'package:flutter_app/common/composition/responsive_widget.dart';
import 'package:flutter_app/common/data/entity/exception/custom_exception.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class ErrorPlaceholderWidget extends StatelessWidget {
  const ErrorPlaceholderWidget({
    required this.onRetry,
    super.key,
    this.exception = const CustomException.general(),
  });

  final VoidCallback onRetry;
  final CustomException exception;

  @override
  Widget build(BuildContext context) {
    return ExpandableSingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Align(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ResponsiveWidget.mediumSizeThreshold),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: exception.getMessage(context: context),
                style: context.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              CustomText(
                text: exception.getDetails(context: context),
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              CustomButtonPrimary(
                onPressed: onRetry,
                text: context.locale.generalErrorStateRetryButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
