import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// setInitialState() - This method can be used to manually set the initial state of the notifier.
///     It will set Loading state on first initialization of the [AsyncNotifier]. If the currentData is not null,
///     it will set the currentData as the initial state. This can happen for example when the notifier is invalidated,
///     or when there is ref.watch used in the build method.

mixin AutoDisposeStateHandler<T> on AnyNotifier<AsyncValue<T>, T> {
  T? get currentData => state.value;

  void setInitialState() => state = currentData == null ? const AsyncLoading() : AsyncData(currentData as T);
  void setStateLoading() => _setStateLoading(() => state = AsyncValue<T>.loading());
  void setStateData(T? data) => _setStateData(data, (data) => state = AsyncData(data));
}

mixin NullableAutoDisposeStateHandler<T> on AnyNotifier<AsyncValue<T?>, T?> {
  T? get currentData => state.value;

  void setInitialState() => state = currentData == null ? const AsyncLoading() : AsyncData(currentData as T);
  void setStateLoading() => _setStateLoading(() => state = AsyncValue<T>.loading());
  void setStateData(T? data) => _setStateDataNullable(data, (data) => state = AsyncData(data));
}

mixin StateHandler<T> on AnyNotifier<AsyncValue<T>, T> {
  T? get currentData => state.value;

  void setInitialState() => state = currentData == null ? const AsyncLoading() : AsyncData(currentData as T);
  void setStateLoading() => _setStateLoading(() => state = AsyncValue<T>.loading());
  void setStateData(T? data) => _setStateData(data, (data) => state = AsyncData(data));
}

mixin NullableStateHandler<T> on AnyNotifier<AsyncValue<T?>, T?> {
  T? get currentData => state.value;

  void setInitialState() => state = currentData == null ? const AsyncLoading() : AsyncData(currentData as T);
  void setStateLoading() => _setStateLoading(() => state = AsyncValue<T>.loading());
  void setStateData(T? data) => _setStateDataNullable(data, (data) => state = AsyncData(data));
}

void _setStateLoading(void Function() onStateChange) {
  try {
    onStateChange();
    // ignore: avoid_catching_errors
  } on StateError catch (e) {
    Flogger.v('$e');
  }
}

void _setStateData<T>(T? data, void Function(T data) onStateChange) {
  try {
    if (data != null) {
      onStateChange(data);
    } else {
      Flogger.e('[AsyncStateHandler] You are trying to set nullable data!!!');
    }
    // ignore: avoid_catching_errors
  } on StateError catch (e) {
    Flogger.v('$e');
  }
}

void _setStateDataNullable<T>(T? data, void Function(T? data) onStateChange) {
  try {
    onStateChange(data);
    // ignore: avoid_catching_errors
  } on StateError catch (e) {
    Flogger.v('$e');
  }
}
