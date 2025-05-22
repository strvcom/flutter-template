import 'package:flutter_app/core/riverpod/event_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_event.freezed.dart';

@freezed
sealed class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.signedOut() = ProfileEventSignedOut;
}

final profileEventNotifierProvider = StateNotifierProvider.autoDispose<EventNotifier<ProfileEvent?>, ProfileEvent?>(
  (ref) => EventNotifier(null),
);
