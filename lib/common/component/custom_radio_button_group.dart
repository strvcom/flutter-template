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
    return RadioGroup<T>(
      groupValue: selectedOption,
      onChanged: (value) {
        if (value != null) {
          onOptionSelected(value);
        }
      },
      child: Column(
        children: options.entries.map(
          (entry) {
            return CustomInkWellRoundedRectangle(
              cornerRadius: 4,
              onClick: () => onOptionSelected(entry.key),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  children: [
                    Radio(
                      value: entry.key,
                      fillColor: WidgetStateProperty.all(context.colorScheme.primary),
                    ),
                    const SizedBox(width: 12),
                    CustomText(text: entry.value, style: context.textTheme.labelLarge),
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
