import 'package:flutter_app/core/riverpod/state_handler.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debug_tools_page_state.freezed.dart';
part 'debug_tools_page_state.g.dart';

enum DebugToolsSampleType {
  widgets,
  popups,
  colors,
  textStyles;
}

@freezed
class DebugToolsPageState with _$DebugToolsPageState {
  const factory DebugToolsPageState({
    @Default(null) DebugToolsSampleType? selectedAction,
  }) = _DebugToolsPageState;
}

@riverpod
class DebugToolsPageStateNotifier extends _$DebugToolsPageStateNotifier with AutoDisposeStateHandler {
  @override
  FutureOr<DebugToolsPageState> build() async {
    return const DebugToolsPageState();
  }

  Future<void> setAction(DebugToolsSampleType? action) async {
    setStateData(currentData?.copyWith(selectedAction: action));
  }
}
