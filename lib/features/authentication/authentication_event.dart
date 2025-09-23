import 'package:flutter_app/core/riverpod/event_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_event.freezed.dart';

@freezed
sealed class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.signedIn() = AuthenticationEventSignedIn;
}

final authenticationEventNotifierProvider = StateNotifierProvider.autoDispose<EventNotifier<AuthenticationEvent?>, AuthenticationEvent?>(
  (ref) => EventNotifier(null),
);
