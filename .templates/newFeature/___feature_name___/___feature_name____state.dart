import 'package:flutter_app/core/riverpod/state_handler.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '___feature_name____state.freezed.dart';
part '___feature_name____state.g.dart';

@freezed
class ___FeatureName___State with _$___FeatureName___State {
  const factory ___FeatureName___State({
    required bool sample,
  }) = ____FeatureName___State;
}

@riverpod
class ___FeatureName___StateNotifier extends _$___FeatureName___StateNotifier with AutoDisposeStateHandler {
  @override
  FutureOr<___FeatureName___State> build() async {
    return const ___FeatureName___State(
      sample: true,
    );
  }
}
