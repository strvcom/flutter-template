import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/common/validator/text_field_validator_state.dart';
import 'package:flutter_app/core/flogger.dart';

abstract class TextValidatorController extends ChangeNotifier {
  TextValidatorController({this.canValidate = false}) {
    controller.addListener(() {
      if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

      _debounceTimer = Timer(
        const Duration(seconds: 1),
        () {
          if (canValidate) validate();
        },
      );
    });
  }

  /// Indicates, if form is validated immediatelly. It's due to postponing validation until some action button is selected.
  bool canValidate;
  final controller = TextEditingController();
  TextFieldValidatorState get state;
  Timer? _debounceTimer;

  String get text {
    return controller.text;
  }

  set text(String text) {
    controller.text = text;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    controller.dispose();

    Flogger.d('[TextFieldValidator] Disposed ${toString()}');

    super.dispose();
  }

  /// Sets `canValidate` to `false` and clear controller text.
  void clear() {
    canValidate = false;
    controller.text = '';
  }

  /// Sets `canValidate` to `true` and calls `validate()` function.
  void forceValidate() {
    canValidate = true;
    validate();
  }

  void validate();
}
