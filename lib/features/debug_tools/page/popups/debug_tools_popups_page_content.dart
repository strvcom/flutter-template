import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_button/custom_button_primary.dart';
import 'package:flutter_app/common/component/custom_date_picker.dart';
import 'package:flutter_app/common/component/custom_snackbar/custom_snackbar_error.dart';
import 'package:flutter_app/common/component/custom_snackbar/custom_snackbar_message.dart';
import 'package:flutter_app/common/component/custom_snackbar/custom_snackbar_success.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/component/custom_time_picker.dart';
import 'package:flutter_app/common/composition/bottom_sheet/bottom_sheet_container_widget.dart';
import 'package:flutter_app/common/composition/dialog/custom_dialog.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_app/features/debug_tools/page/popups/debug_tools_list_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DebugToolsPopupsPageContent extends ConsumerWidget {
  const DebugToolsPopupsPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        CustomText(text: 'Dialogs', style: context.textTheme.headlineLarge),
        const SizedBox(height: 20),
        CustomButtonPrimary(
          onPressed: () => CustomDialog.alert(
            context: context,
            title: 'Delete event',
            message: "Are you sure you want to delete this event? This action will delete all data and can't be recovered.",
            negativeActionTitle: 'Delete',
            negativeAction: () => CustomSnackbarMessage(context: context, message: 'Event deleted').show(),
            neutralActionTitle: 'Cancel',
          ).show(),
          text: 'Custom Alert dialog',
        ),
        const SizedBox(height: 16),
        CustomButtonPrimary(
          onPressed: () => DebugToolsListDialog(
            context: context,
            title: 'List dialog',
            list: ['one', 'two', 'three', 'four', 'five'],
            onItemSelect: (item) => CustomSnackbarMessage(context: context, message: 'Clicked $item').show(),
          ).show(),
          text: 'Custom dialog',
        ),
        const SizedBox(height: 16),
        CustomButtonPrimary(
          onPressed: () => showCustomModalBottomSheet<void>(
            context: context,
            containerWidget: (context, animation, child) => BottomSheetContainerWidget(child: child),
            builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(text: 'Some scrollable content here', style: context.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Placeholder(fallbackHeight: 200),
                  const SizedBox(height: 8),
                  CustomButtonPrimary(onPressed: () {}, text: 'Some sample button'),
                ],
              ),
            ),
          ),
          text: 'Bottom Sheet Base Widget',
        ),
        const SizedBox(height: 20),
        CustomButtonPrimary(
          onPressed: () async {
            final pickedDate = await CustomDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              currentDate: DateTime.now(),
            ).show();

            if (pickedDate != null) {
              Flogger.d('Picked date: $pickedDate');
            }
          },
          text: 'Custom Date Picker',
        ),
        const SizedBox(height: 20),
        CustomButtonPrimary(
          onPressed: () async {
            final pickedTime = await CustomTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            ).show();

            if (pickedTime != null) {
              Flogger.d('Picked time: $pickedTime');
            }
          },
          text: 'Custom Time Picker',
        ),
        const SizedBox(height: 64),
        CustomText(text: 'Snackbars', style: context.textTheme.headlineLarge),
        const SizedBox(height: 20),
        CustomButtonPrimary(
          onPressed: () => CustomSnackbarMessage(
            context: context,
            message: 'Example of message snackbar',
          ).show(),
          text: 'Show Message snackbar',
        ),
        const SizedBox(height: 16),
        CustomButtonPrimary(
          onPressed: () => CustomSnackbarError(
            context: context,
            message: 'Example of error state widget',
          ).show(),
          text: 'Show Error snackbar',
        ),
        const SizedBox(height: 16),
        CustomButtonPrimary(
          onPressed: () => CustomSnackbarSuccess(
            context: context,
            message: 'Example of confirmation widget',
          ).show(),
          text: 'Show Confirmation snackbar',
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
