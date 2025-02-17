import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.dense = false,
  });

  final String title;
  final bool value;
  final Function(bool value) onChanged;
  final String? subtitle;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      title: CustomText(text: title, style: context.textTheme.labelLarge),
      subtitle: (subtitle != null)
          ? CustomText(
              text: subtitle!,
              style: context.textTheme.labelSmall,
              color: context.colorScheme.onPrimary.withValues(alpha: 0.5),
            )
          : null,
      value: value,
      onChanged: onChanged,
      dense: dense,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: EdgeInsets.zero,
      activeColor: context.colorScheme.primary,
      inactiveThumbColor: Colors.grey.shade600,
      inactiveTrackColor: Colors.grey.shade400,
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      overlayColor: WidgetStateProperty.all(context.colorScheme.primary.withValues(alpha: 0.1)),
      hoverColor: context.colorScheme.primary.withValues(alpha: 0.1),
    );
  }
}
