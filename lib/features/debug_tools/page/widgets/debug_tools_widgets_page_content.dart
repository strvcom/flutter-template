import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_button/custom_button_primary.dart';
import 'package:flutter_app/common/component/custom_radio_button_group.dart';
import 'package:flutter_app/common/component/custom_snackbar/custom_snackbar_message.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/component/custom_text_field.dart';
import 'package:flutter_app/common/component/custom_text_field_button.dart';
import 'package:flutter_app/common/extension/async_value.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_app/features/debug_tools/page/widgets/debug_tools_widgets_page_event.dart';
import 'package:flutter_app/features/debug_tools/page/widgets/debug_tools_widgets_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebugToolsWidgetsPageContent extends ConsumerWidget {
  const DebugToolsWidgetsPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(debugToolsWidgetsPageStateNotifierProvider);

    ref.listen(
      debugToolsWidgetsPageEventNotifierProvider,
      (_, next) => switch (next) {
        DebugToolsWidgetsPageEventFieldValidated(message: final message) => CustomSnackbarMessage(
            context: context,
            message: message,
          ).show(),
        _ => () {},
      },
    );

    return state.mapContentState(
      provider: debugToolsWidgetsPageStateNotifierProvider,
      data: (data) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CustomText(text: 'Custom Buttons', style: context.textTheme.headlineLarge),
          const SizedBox(height: 20),
          CustomButtonPrimary(text: 'Primary', onPressed: () {}),
          const SizedBox(height: 64),
          CustomText(text: 'CustomTextField', style: context.textTheme.headlineLarge),
          const SizedBox(height: 20),
          CustomTextField(
            label: 'Example of custom text field',
            validatorController: ref.read(debugToolsWidgetsPageStateNotifierProvider.notifier).exampleTextController,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),
          CustomButtonPrimary(
            onPressed: () => ref.read(debugToolsWidgetsPageStateNotifierProvider.notifier).validateSampleTextField(),
            text: 'Validate text field',
          ),
          const SizedBox(height: 16),
          CustomText(text: 'CustomTextFieldButton', style: context.textTheme.headlineLarge),
          const SizedBox(height: 20),
          CustomTextFieldButton(
            label: 'Example of custom text field button',
            validatorController: ref.read(debugToolsWidgetsPageStateNotifierProvider.notifier).exampleTextController,
            enabled: true,
            onClick: () => Flogger.d('Clicked text field button'),
          ),
          const SizedBox(height: 64),
          CustomText(text: 'CustomRadioButtonGroup', style: context.textTheme.headlineLarge),
          const SizedBox(height: 16),
          CustomRadioButtonGroup(
            options: const {'First': 'First', 'Second': 'Second', 'Third': 'Third'},
            selectedOption: data.selectedOption,
            onOptionSelected: (newOption) => ref.read(debugToolsWidgetsPageStateNotifierProvider.notifier).onOptionChanged(newOption),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
