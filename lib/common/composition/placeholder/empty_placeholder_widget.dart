import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_button/custom_button_primary.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/composition/expandable_single_child_scroll_view.dart';
import 'package:flutter_app/common/composition/responsive_widget.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class EmptyPlaceholderWidget extends StatelessWidget {
  const EmptyPlaceholderWidget({
    super.key,
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ExpandableSingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ResponsiveWidget.mediumSizeTreshold),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(text: context.locale.generalEmptyStateTitle, style: context.textTheme.titleMedium),
              const SizedBox(height: 8),
              CustomText(text: context.locale.generalEmptyStateBody, style: context.textTheme.bodyMedium),
              const SizedBox(height: 32),
              CustomButtonPrimary(onPressed: onRetry, text: context.locale.generalEmptyStateRetryButton),
            ],
          ),
        ),
      ),
    );
  }
}
