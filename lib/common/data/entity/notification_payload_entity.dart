import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_payload_entity.freezed.dart';
part 'notification_payload_entity.g.dart';

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
sealed class NotificationPayloadEntity with _$NotificationPayloadEntity {
  const NotificationPayloadEntity._();

  // Title: Sample
  const factory NotificationPayloadEntity.sample({
    required int id,
    required String title,
    required String body,
  }) = _Sample;

  // Title: Unknown
  const factory NotificationPayloadEntity.unknown() = _Unknown;

  factory NotificationPayloadEntity.fromJson(Map<String, dynamic> json) {
    switch (NotificationType.fromString(json['type'] as String?)) {
      case NotificationType.sample:
        return _Sample.fromJson(json);

      case NotificationType.unknown:
        return const _Unknown();
    }
  }
}
