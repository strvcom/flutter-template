import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier which is used only to listen.
class EventNotifier<T> extends Notifier<T?> {
  /// Creates an [EventNotifier] with the given [state].
  EventNotifier() : super();

  /// Updates the state with the provided event.
  // ignore: use_setters_to_change_properties
  void send(T event) {
    state = event;
  }

  @override
  T? build() {
    return state;
  }
}
