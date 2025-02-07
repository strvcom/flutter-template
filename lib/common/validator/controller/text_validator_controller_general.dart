import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/data/model/exception/validator_exception.dart';
import 'package:flutter_app/common/validator/text_field_validator_state.dart';
import 'package:flutter_app/common/validator/text_validator_controller.dart';

class TextValidatorControllerGeneral extends TextValidatorController {
  TextValidatorControllerGeneral({
    this.emptyText,
    this.minLength,
    this.tooShortText,
    this.maxLength,
    this.tooLongText,
    this.regex,
    this.regexText,
    this.condition,
    this.conditionText,
  }) {
    if (tooShortText != null && minLength == null) throw Exception('minLength must be also set when tooShortText is set.');
    if (minLength != null && tooShortText == null) throw Exception('tooShortText must be also set when minLength is set.');

    if (tooLongText != null && maxLength == null) throw Exception('maxLength must be also set when tooLongText is set.');
    if (maxLength != null && tooLongText == null) throw Exception('tooLongText must be also set when maxLength is set.');

    if (regexText != null && regex == null) throw Exception('regex must be also set when regexText is set.');
    if (regex != null && regexText == null) throw Exception('regexText must be also set when regex is set.');

    if (conditionText != null && condition == null) throw Exception('condition must be also set when conditionText is set.');
    if (condition != null && conditionText == null) throw Exception('conditionText must be also set when condition is set.');
  }

  final String Function(BuildContext context)? emptyText;
  final int? minLength;
  final String Function(BuildContext context)? tooShortText;
  final int? maxLength;
  final String Function(BuildContext context)? tooLongText;
  final RegExp? regex;
  final String Function(BuildContext context)? regexText;
  final bool Function(String text)? condition;
  final String Function(BuildContext context)? conditionText;

  TextFieldValidatorState _state = const TextFieldValidatorState.initial();

  @override
  TextFieldValidatorState get state => _state;

  @override
  void validate() {
    if (!canValidate) return;

    final text = controller.text;

    if (text.isEmpty && emptyText != null) {
      _state = TextFieldValidatorState.invalid(exception: ValidatorException.generalIsEmpty(emptyText!));
    } else if (minLength != null && text.length < minLength!) {
      _state = TextFieldValidatorState.invalid(exception: ValidatorException.generalIsTooShort(tooShortText!));
    } else if (maxLength != null && text.length > maxLength!) {
      _state = TextFieldValidatorState.invalid(exception: ValidatorException.generalIsTooLong(tooLongText!));
    } else if (regex != null && !regex!.hasMatch(text)) {
      _state = TextFieldValidatorState.invalid(exception: ValidatorException.generalIsInvalid(regexText!));
    } else if (condition?.call(text) ?? false) {
      _state = TextFieldValidatorState.invalid(exception: ValidatorException.generalIsInvalid(conditionText!));
    } else {
      _state = const TextFieldValidatorState.valid();
    }

    notifyListeners();
  }
}
