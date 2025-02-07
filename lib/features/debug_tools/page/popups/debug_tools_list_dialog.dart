import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_ink_well/custom_ink_well_rounded_rectangle.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/composition/dialog/custom_dialog_wrapper.dart';
import 'package:flutter_app/common/composition/responsive_widget.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class DebugToolsListDialog {
  DebugToolsListDialog({
    required this.context,
    required this.title,
    required this.list,
    required this.onItemSelect,
  });

  final BuildContext context;
  final String title;
  final List<String> list;
  final void Function(String listItem) onItemSelect;

  Future<bool?> show() async {
    return await showDialog<bool>(
      context: context,
      builder: (builderContext) => CustomDialogWrapper.custom(
        context: builderContext,
        title: title,
        content: SizedBox(
          width: ResponsiveWidget.mediumSizeTreshold,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: list.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 1, color: context.colorScheme.divider),
            ),
            itemBuilder: (context, index) {
              final item = list[index];
              return CustomInkWellRoundedRectangle(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                cornerRadius: 8,
                onClick: () {
                  onItemSelect(item);
                  Navigator.of(builderContext).pop(true);
                },
                child: CustomText(text: item, style: context.textTheme.bodyMedium),
              );
            },
          ),
        ),
      ),
    );
  }
}
