import 'package:flutter/material.dart';
import 'package:flutter_app/common/data/model/exception/validator_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_field_validator_state.freezed.dart';

@freezed
sealed class TextFieldValidatorState with _$TextFieldValidatorState {
  const TextFieldValidatorState._();

  const factory TextFieldValidatorState.initial() = TextFieldValidatorStateInitial;
  const factory TextFieldValidatorState.valid() = TextFieldValidatorStateValid;
  const factory TextFieldValidatorState.invalid({required ValidatorException exception}) = TextFieldValidatorStateInvalid;

  bool get isValid {
    return switch (this) {
      TextFieldValidatorStateValid() => true,
      _ => false,
    };
  }

  bool get hasError {
    return switch (this) {
      TextFieldValidatorStateInvalid() => true,
      _ => false,
    };
  }

  String? getErrorMessage(BuildContext context) {
    return switch (this) {
      TextFieldValidatorStateInvalid(exception: final exception) => exception.getMessage(context: context),
      _ => null,
    };
  }
}
