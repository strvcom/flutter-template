import 'package:flutter_app/common/data/entity/exception/custom_exception.dart';
import 'package:flutter_app/core/riverpod/event_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_event.freezed.dart';

@freezed
sealed class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.signedOut() = _SignedOut;
  const factory ProfileEvent.error(CustomException e) = _Error;
}

final profileEventNotifierProvider = NotifierProvider.autoDispose<EventNotifier<ProfileEvent?>, ProfileEvent?>(
  EventNotifier.new,
);
