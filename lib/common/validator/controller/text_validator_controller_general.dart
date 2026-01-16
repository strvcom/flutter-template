import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/data/entity/exception/validator_exception.dart';
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
    if ((tooShortText != null && minLength == null) || (minLength != null && tooShortText == null)) {
      throw Exception('minLength and tooShortText must be set together.');
    } else if ((tooLongText != null && maxLength == null) || (maxLength != null && tooLongText == null)) {
      throw Exception('maxLength and tooLongText must be set together.');
    } else if ((regexText != null && regex == null) || (regex != null && regexText == null)) {
      throw Exception('regex and regexText must be set together.');
    } else if ((conditionText != null && condition == null) || (condition != null && conditionText == null)) {
      throw Exception('condition and conditionText must be set together.');
    }
  }

  final String Function(BuildContext context)? emptyText;
  final int? minLength;
  final String Function(BuildContext context)? tooShortText;
  final int? maxLength;
  final String Function(BuildContext context)? tooLongText;
  final RegExp? regex;
  final String Function(BuildContext context)? regexText;
  final Future<bool> Function(String text)? condition;
  final String Function(BuildContext context)? conditionText;

  TextFieldValidatorState _state = const TextFieldValidatorState.initial();

  @override
  TextFieldValidatorState get state => _state;

  @override
  Future<void> validate() async {
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
    } else if (condition != null && await condition!(text)) {
      _state = TextFieldValidatorState.invalid(exception: ValidatorException.generalIsInvalid(conditionText!));
    } else {
      _state = const TextFieldValidatorState.valid();
    }

    notifyListeners();
  }

  bool get isValid => _state.isValid;
}
