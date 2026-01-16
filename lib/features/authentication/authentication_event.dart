import 'package:flutter_app/common/data/entity/exception/custom_exception.dart';
import 'package:flutter_app/core/riverpod/event_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_event.freezed.dart';

@freezed
sealed class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.signedIn() = AuthenticationEventSignedIn;
  const factory AuthenticationEvent.error(CustomException exception) = _Error;
}

final authenticationEventNotifierProvider = NotifierProvider.autoDispose<EventNotifier<AuthenticationEvent?>, AuthenticationEvent?>(
  EventNotifier.new,
);
