import 'package:flutter_app/core/riverpod/event_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'debug_tools_widgets_page_event.freezed.dart';

@freezed
class DebugToolsWidgetsPageEvent with _$DebugToolsWidgetsPageEvent {
  const factory DebugToolsWidgetsPageEvent.fieldValidated({required String message}) = _DebugToolsSomeEvent;
}

final debugToolsWidgetsPageEventNotifierProvider =
    StateNotifierProvider.autoDispose<EventNotifier<DebugToolsWidgetsPageEvent?>, DebugToolsWidgetsPageEvent?>(
        (ref) => EventNotifier(null));
