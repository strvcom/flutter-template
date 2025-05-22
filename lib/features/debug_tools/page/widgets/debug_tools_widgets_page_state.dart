import 'package:flutter_app/common/validator/controller/text_validator_controller_full_name.dart';
import 'package:flutter_app/core/riverpod/state_handler.dart';
import 'package:flutter_app/features/debug_tools/page/widgets/debug_tools_widgets_page_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debug_tools_widgets_page_state.freezed.dart';
part 'debug_tools_widgets_page_state.g.dart';

@freezed
abstract class DebugToolsWidgetsPageState with _$DebugToolsWidgetsPageState {
  const factory DebugToolsWidgetsPageState({
    required String sampleFieldValidMessage,
    required String selectedOption,
  }) = _DebugToolsWidgetsPageState;
  const DebugToolsWidgetsPageState._();
}

@riverpod
class DebugToolsWidgetsPageStateNotifier extends _$DebugToolsWidgetsPageStateNotifier with AutoDisposeStateHandler {
  // Warning: Text controllers must be always late. It can cause issues on some flows, where they get disposed and not initialized again.
  late TextValidatorControllerFullName exampleTextController;

  @override
  FutureOr<DebugToolsWidgetsPageState> build() async {
    exampleTextController = TextValidatorControllerFullName();

    ref.onDispose(() {
      exampleTextController.dispose();
    });

    return const DebugToolsWidgetsPageState(
      sampleFieldValidMessage: 'not decided yet',
      selectedOption: 'Second',
    );
  }

  void validateSampleTextField() {
    _validateTextFields();

    ref
        .read(debugToolsWidgetsPageEventNotifierProvider.notifier)
        .send(DebugToolsWidgetsPageEvent.fieldValidated(message: currentData!.sampleFieldValidMessage));
  }

  bool _validateTextFields() {
    exampleTextController.forceValidate();

    setStateData(
      currentData?.copyWith(sampleFieldValidMessage: exampleTextController.state.isValid ? 'Field is valid ;)' : 'Field is not valid!'),
    );

    return exampleTextController.state.isValid;
  }

  void onOptionChanged(String newOption) {
    setStateData(currentData?.copyWith(selectedOption: newOption));
  }
}
