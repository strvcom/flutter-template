import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier which is used only to listen.
class EventNotifier<T> extends StateNotifier<T> {
  EventNotifier(super.state);

  @override
  bool updateShouldNotify(T old, T current) {
    return true;
  }

  void send(T event) {
    state = event;
  }
}
