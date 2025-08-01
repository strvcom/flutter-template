import 'package:flutter_app/common/data/entity/exception/custom_exception.dart';
import 'package:flutter_app/core/riverpod/event_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '___feature_name____event.freezed.dart';

@freezed
sealed class ___FeatureName___Event with _$___FeatureName___Event {
  const factory ___FeatureName___Event.error(CustomException error) = _Error;
}

final ___featureName___EventNotifierProvider =
    StateNotifierProvider.autoDispose<EventNotifier<___FeatureName___Event?>, ___FeatureName___Event?>((ref) => EventNotifier(null));
