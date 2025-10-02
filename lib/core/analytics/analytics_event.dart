import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_event.freezed.dart';

@freezed
sealed class AnalyticsEvent with _$AnalyticsEvent {
  factory AnalyticsEvent({
    required String firebaseEventId,
    Map<String, String>? firebaseEventParams,
  }) = _AnalyticsEvent;

  factory AnalyticsEvent.onSampleEvent() => AnalyticsEvent(firebaseEventId: 'on_sample_event');
  factory AnalyticsEvent.onAnotherSampleEvent({required String sampleParamValue}) => AnalyticsEvent(
    firebaseEventId: 'on_another_sample_event',
    firebaseEventParams: {'sample_parameter_id': sampleParamValue},
  );
}
