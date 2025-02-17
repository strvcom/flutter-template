import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_ink_well/custom_ink_well_rounded_rectangle.dart';
import 'package:flutter_app/common/component/custom_text_field.dart';
import 'package:flutter_app/common/validator/text_validator_controller.dart';

class CustomTextFieldButton extends StatelessWidget {
  const CustomTextFieldButton({
    super.key,
    required this.onClick,
    this.label,
    this.controller,
    this.validatorController,
    this.enabled = true,
  }) : assert(!(controller != null && validatorController != null), 'You can only provide controller or validationController!');

  final VoidCallback onClick;
  final String? label;
  final TextEditingController? controller;
  final TextValidatorController? validatorController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CustomInkWellRoundedRectangle(
      cornerRadius: 16,
      onClick: enabled ? onClick : null,
      child: FocusScope(
        canRequestFocus: false,
        child: CustomTextField(
          label: label,
          controller: controller,
          validatorController: validatorController,
          readOnly: true,
          enabled: enabled,
        ),
      ),
    );
  }
}
