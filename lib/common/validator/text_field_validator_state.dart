import 'package:flutter/material.dart';
import 'package:flutter_app/common/data/model/exception/validator_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_field_validator_state.freezed.dart';

@freezed
class TextFieldValidatorState with _$TextFieldValidatorState {
  const TextFieldValidatorState._();

  const factory TextFieldValidatorState.initial() = _Initial;
  const factory TextFieldValidatorState.valid() = _Valid;
  const factory TextFieldValidatorState.invalid({required ValidatorException exception}) = _Invalid;

  bool get isValid {
    return mapOrNull(valid: (_) => true) ?? false;
  }

  bool get hasError {
    return mapOrNull(invalid: (_) => true) ?? false;
  }

  String? getErrorMessage(BuildContext context) {
    return mapOrNull(invalid: (value) => value.exception.getMessage(context: context));
  }
}
