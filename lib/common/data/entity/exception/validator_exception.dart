import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'validator_exception.freezed.dart';

@freezed
sealed class ValidatorException with _$ValidatorException implements Exception {
  const ValidatorException._();

  const factory ValidatorException.generalIsEmpty(String Function(BuildContext) getText) = ValidatorExceptionGeneralIsEmpty;
  const factory ValidatorException.generalIsTooShort(String Function(BuildContext) getText) = ValidatorExceptionGeneralIsTooShort;
  const factory ValidatorException.generalIsTooLong(String Function(BuildContext) getText) = ValidatorExceptionGeneralIsTooLong;
  const factory ValidatorException.generalIsInvalid(String Function(BuildContext) getText) = ValidatorExceptionGeneralIsInvalid;

  String getMessage({required BuildContext context}) {
    return switch (this) {
      ValidatorExceptionGeneralIsEmpty(getText: final getText) => getText(context),
      ValidatorExceptionGeneralIsTooShort(getText: final getText) => getText(context),
      ValidatorExceptionGeneralIsTooLong(getText: final getText) => getText(context),
      ValidatorExceptionGeneralIsInvalid(getText: final getText) => getText(context),
    };
  }
}
