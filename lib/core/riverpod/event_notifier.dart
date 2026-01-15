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

  /// Always returns true to notify even about the same event
  /// It was causing issues when navigating back and forth and emitting the same event that was used to navigate
  @override
  bool updateShouldNotify(T? previous, T? next) {
    return true;
  }
}
