import 'package:flutter_app/core/flogger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// setInitialState() - This method can be used to manually set the initial state of the notifier.
///     It will set Loading state on first initialization of the [AsyncNotifier]. If the currentData is not null,
///     it will set the currentData as the initial state. This can happen for example when the notifier is invalidated,
///     or when there is ref.watch used in the build method.

// ignore: invalid_use_of_internal_member
mixin AutoDisposeStateHandler<T> on BuildlessAutoDisposeAsyncNotifier<T> {
  T? get currentData => state.valueOrNull;

  void setInitialState() => state = currentData == null ? const AsyncLoading() : AsyncData(currentData as T);
  void setStateLoading() => _setStateLoading(() => state = AsyncValue<T>.loading());
  void setStateData(T? data) => _setStateData(data, (data) => state = AsyncData(data));
}

// ignore: invalid_use_of_internal_member
mixin NullableAutoDisposeStateHandler<T> on BuildlessAutoDisposeAsyncNotifier<T?> {
  T? get currentData => state.valueOrNull;

  void setInitialState() => state = currentData == null ? const AsyncLoading() : AsyncData(currentData as T);
  void setStateLoading() => _setStateLoading(() => state = AsyncValue<T>.loading());
  void setStateData(T? data) => _setStateDataNullable(data, (data) => state = AsyncData(data));
}

// ignore: invalid_use_of_internal_member
mixin StateHandler<T> on BuildlessAsyncNotifier<T> {
  T? get currentData => state.valueOrNull;

  void setInitialState() => state = currentData == null ? const AsyncLoading() : AsyncData(currentData as T);
  void setStateLoading() => _setStateLoading(() => state = AsyncValue<T>.loading());
  void setStateData(T? data) => _setStateData(data, (data) => state = AsyncData(data));
}

// ignore: invalid_use_of_internal_member
mixin NullableStateHandler<T> on BuildlessAsyncNotifier<T?> {
  T? get currentData => state.valueOrNull;

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
