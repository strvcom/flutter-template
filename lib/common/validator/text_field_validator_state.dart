import 'package:flutter/material.dart';
import 'package:flutter_app/common/data/entity/exception/validator_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_field_validator_state.freezed.dart';

@freezed
sealed class TextFieldValidatorState with _$TextFieldValidatorState {
  const TextFieldValidatorState._();

  const factory TextFieldValidatorState.initial() = _Initial;
  const factory TextFieldValidatorState.valid() = _Valid;
  const factory TextFieldValidatorState.invalid({required ValidatorException exception}) = _Invalid;

  bool get isValid => maybeWhen(
    valid: () => true,
    orElse: () => false,
  );

  bool get hasError => maybeWhen(
    invalid: (_) => true,
    orElse: () => false,
  );

  String? getErrorMessage(BuildContext context) => whenOrNull(invalid: (exception) => exception.getMessage(context: context));
}
