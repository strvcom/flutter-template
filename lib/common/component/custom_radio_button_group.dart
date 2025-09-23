import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_ink_well/custom_ink_well_rounded_rectangle.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class CustomRadioButtonGroup<T> extends StatelessWidget {
  const CustomRadioButtonGroup({
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
    super.key,
  });

  final Map<T, String> options;
  final T? selectedOption;
  final ValueChanged<T> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.entries.map(
        (entry) {
          void onOptionClick() {
            onOptionSelected(entry.key);
          }

          return CustomInkWellRoundedRectangle(
            cornerRadius: 4,
            onClick: onOptionClick,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                children: [
                  Radio(
                    value: entry.key,
                    groupValue: selectedOption,
                    fillColor: WidgetStateProperty.all(context.colorScheme.primary),
                    onChanged: (_) => onOptionClick,
                  ),
                  const SizedBox(width: 12),
                  CustomText(text: entry.value, style: context.textTheme.labelLarge),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
