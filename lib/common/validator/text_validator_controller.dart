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

  /// Text field controller.
  final controller = TextEditingController();

  /// Indicates, if form is validated immediately. It's due to postponing validation until some action button is selected.
  bool canValidate;

  /// State of the validator.
  TextFieldValidatorState get state;

  /// Debounce timer to postpone validation.
  Timer? _debounceTimer;

  String get text => controller.text;
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
  Future<void> forceValidate() async {
    canValidate = true;
    await validate();
  }

  Future<void> validate();
}
