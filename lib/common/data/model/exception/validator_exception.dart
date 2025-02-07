import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'validator_exception.freezed.dart';

@freezed
class ValidatorException with _$ValidatorException implements Exception {
  const ValidatorException._();

  const factory ValidatorException.generalIsEmpty(String Function(BuildContext) getText) = _GeneralIsEmpty;
  const factory ValidatorException.generalIsTooShort(String Function(BuildContext) getText) = _GeneralIsTooShort;
  const factory ValidatorException.generalIsTooLong(String Function(BuildContext) getText) = _GeneralIsTooLong;
  const factory ValidatorException.generalIsInvalid(String Function(BuildContext) getText) = _GeneralIsInvalid;

  String getMessage({required BuildContext context}) {
    return map(
      generalIsEmpty: (value) => value.getText(context),
      generalIsTooShort: (value) => value.getText(context),
      generalIsTooLong: (value) => value.getText(context),
      generalIsInvalid: (value) => value.getText(context),
    );
  }
}
