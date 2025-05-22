import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/common/validator/controller/text_validator_controller_general.dart';

class TextValidatorControllerFullName extends TextValidatorControllerGeneral {
  TextValidatorControllerFullName()
    : super(
        emptyText: (context) => context.locale.validatorExceptionFullNameIsEmpty,
        minLength: 3,
        tooShortText: (context) => context.locale.validatorExceptionFullNameTooShort,
        maxLength: 48,
        tooLongText: (context) => context.locale.validatorExceptionFullNameTooLong,
        regex: RegExp(r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$", caseSensitive: false),
        regexText: (context) => context.locale.validatorExceptionFullNameIsInvalid,
      );
}
