import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/assets.gen.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/common/validator/text_validator_controller.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.label,
    this.controller,
    this.validatorController,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.maxLines,
    this.textAlign = TextAlign.start,
    this.textInputAction,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
    this.inputFormatters,
    this.withCounterText = false,
    this.note,
    this.prefix,
  }) : assert(!(controller != null && validatorController != null), 'You can only provide controller or validationController!'),
       assert(!(withCounterText && maxLength == null), 'maxLength must be set when the withCounterText is used!');

  final String? label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final List<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final TextValidatorController? validatorController;
  final int? maxLength;
  final int? maxLines;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool enabled;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final bool withCounterText;
  final String? note;
  final Widget? prefix;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  int textLength = 0;
  final _focusNode = FocusNode();
  bool hasFocus = false;
  String lastErrorMessage = '';

  TextEditingController? get _controller => widget.validatorController?.controller ?? widget.controller;

  @override
  void initState() {
    super.initState();
    widget.validatorController?.addListener(_onValidatorChange);
    _focusNode.addListener(_onFocusChange);

    textLength = widget.validatorController?.text.length ?? widget.controller?.text.length ?? 0;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentTopPadding = (widget.label == null) ? 17.0 : 9.0;
    final contentBottomPadding = (widget.label == null) ? 20.0 : 12.0;

    // Subtitle: Enabled State colors
    var inputBgColor = context.colorScheme.surfaceVariant;
    var inputTextColor = context.colorScheme.onSurface;
    var labelTextColor = context.colorScheme.onSurface;
    var floatingLabelTextColor = context.colorScheme.onSurface;
    final errorTextColor = context.colorScheme.error;
    final counterTextColor = context.colorScheme.onSurface;
    final noteTextColor = context.colorScheme.onSurface;

    if (hasFocus) {
      // Subtitle: Focused State colors
      inputBgColor = context.colorScheme.surfaceVariant;
      inputTextColor = context.colorScheme.onSurface;
      labelTextColor = context.colorScheme.onSurface;
      floatingLabelTextColor = context.colorScheme.onSurface;
    } else if (!widget.enabled) {
      // Subtitle: Disabled State colors
      inputBgColor = context.colorScheme.surfaceVariant;
      inputTextColor = context.colorScheme.onSurface.withValues(alpha: 0.5);
      labelTextColor = context.colorScheme.onSurface.withValues(alpha: 0.5);
      floatingLabelTextColor = context.colorScheme.onSurface.withValues(alpha: 0.5);
    }

    final errorMessage = widget.validatorController?.state.getErrorMessage(context) ?? '';
    if (errorMessage.isNotEmpty) {
      lastErrorMessage = errorMessage;
    }

    return Theme(
      data: context.theme.copyWith(
        colorScheme: context.theme.colorScheme.copyWith(
          shadow: context.colorScheme.shadow,
          surface: context.colorScheme.surface,
          onSurface: context.colorScheme.onSurface,
        ),
      ), // Background color and shadow color of Selection Options panel
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title: Input field
          TextField(
            autofillHints: widget.autofillHints,
            textInputAction: widget.textInputAction,
            textAlign: widget.textAlign,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            focusNode: _focusNode,
            controller: _controller,
            style: context.textTheme.labelLarge.copyWith(color: inputTextColor),
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType,
            textCapitalization: widget.textCapitalization,
            onTapOutside: (_) => _focusNode.unfocus(),
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            onChanged: (value) => setState(() => textLength = value.length),
            decoration: InputDecoration(
              prefix: widget.prefix,
              counter: (widget.withCounterText)
                  ? Container(
                      padding: (widget.withCounterText) ? const EdgeInsets.only(bottom: 12) : EdgeInsets.zero,
                      child: CustomText(
                        text: '$textLength / ${widget.maxLength}',
                        style: context.textTheme.labelMedium,
                        color: inputTextColor,
                      ),
                    )
                  : null,
              counterText: '', // Always hide counter
              counterStyle: context.textTheme.labelMedium.copyWith(color: counterTextColor),
              contentPadding: EdgeInsets.only(
                top: contentTopPadding,
                bottom: contentBottomPadding,
                left: 16,
                right: 16,
              ),
              filled: true,
              fillColor: inputBgColor,
              // enabledBorder and focusedBorder needs to be both set to make underline invisible
              enabledBorder: UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16),
              ),
              labelText: widget.label,
              alignLabelWithHint: widget.maxLines != null,
              labelStyle: context.textTheme.labelLarge.copyWith(color: labelTextColor),
              floatingLabelStyle: context.textTheme.labelLarge.copyWith(color: floatingLabelTextColor),
            ),
          ),

          // Title: Error widget
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            firstChild: _ErrorContentWidget(
              errorMessage: widget.validatorController?.state.getErrorMessage(context) ?? lastErrorMessage,
              errorTextColor: errorTextColor,
            ),
            secondChild: SizedBox(
              height: 0,
              child: _ErrorContentWidget(
                errorMessage: '',
                errorTextColor: errorTextColor,
              ),
            ),
            crossFadeState: (widget.validatorController?.state.hasError ?? false) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),

          // Title: Bottom note text
          if (widget.note != null)
            CustomText(
              text: widget.note!,
              style: context.textTheme.labelMedium,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: noteTextColor,
            ),
        ],
      ),
    );
  }

  void _onFocusChange() {
    setState(() {
      hasFocus = _focusNode.hasFocus;
    });

    if (!_focusNode.hasFocus) {
      widget.validatorController?.forceValidate();
    }
  }

  void _onValidatorChange() {
    if (!mounted) return;

    setState(() {});
  }
}

class _ErrorContentWidget extends StatelessWidget {
  const _ErrorContentWidget({
    required this.errorMessage,
    required this.errorTextColor,
  });

  final String errorMessage;
  final Color errorTextColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              text: errorMessage,
              style: context.textTheme.labelMedium,
              color: errorTextColor,
              maxLines: 2,
            ),
          ),
          const SizedBox(width: 4),
          Assets.svg.icErrorCircle.svg(),
        ],
      ),
    );
  }
}
