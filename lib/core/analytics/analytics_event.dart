import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_event.freezed.dart';

@freezed
abstract class AnalyticsEvent with _$AnalyticsEvent {
  factory AnalyticsEvent._({
    required String firebaseEventId,
    Map<String, String>? firebaseEventParams,
  }) = _AnalyticsEvent;

  factory AnalyticsEvent.onSampleEvent() => AnalyticsEvent._(firebaseEventId: 'on_sample_event');
  factory AnalyticsEvent.onAnotherSampleEvent({required String sampleParamValue}) => AnalyticsEvent._(
        firebaseEventId: 'on_another_sample_event',
        firebaseEventParams: {'sample_parameter_id': sampleParamValue},
      );
}
