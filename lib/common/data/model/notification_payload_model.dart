import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_payload_model.freezed.dart';
part 'notification_payload_model.g.dart';

@JsonEnum(valueField: 'value', alwaysCreate: true)
enum NotificationType {
  sample('sample'),
  unknown('unknown');

  const NotificationType(this.value);
  final String value;

  static NotificationType fromString(String? value) =>
      NotificationType.values.firstWhereOrNull((e) => e.value == value) ?? NotificationType.unknown;
}

@Freezed(fromJson: true, toJson: true)
sealed class NotificationPayloadModel with _$NotificationPayloadModel {
  const NotificationPayloadModel._();

  // Title: Sample
  const factory NotificationPayloadModel.sample({
    required int id,
    required String title,
    required String body,
    @Default(NotificationType.sample) NotificationType type,
  }) = NotificationPayloadModelSample;

  // Subtitle: unknown
  const factory NotificationPayloadModel.unknown({
    @Default(-1) int id,
    @Default('') String title,
    @Default('') String body,
    @Default(NotificationType.unknown) NotificationType type,
  }) = NotificationPayloadModelUnknown;

  factory NotificationPayloadModel.fromJson(Map<String, dynamic> json) {
    switch (NotificationType.fromString(json['type'])) {
      case NotificationType.sample:
        return NotificationPayloadModelSample.fromJson(json);

      default:
        return const NotificationPayloadModelUnknown();
    }
  }
}
