import 'package:flutter/material.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class DebugToolsTextStyle {
  DebugToolsTextStyle({
    required this.textStyle,
    required this.name,
  });

  final TextStyle? textStyle;
  final String name;

  static List<DebugToolsTextStyle> getTextStyles({required BuildContext context, required Brightness brightness}) {
    final textTheme = context.textTheme;

    return [
      DebugToolsTextStyle(textStyle: textTheme.displayLarge, name: 'displayLarge'),
      DebugToolsTextStyle(textStyle: textTheme.displayMedium, name: 'displayMedium'),
      DebugToolsTextStyle(textStyle: textTheme.displaySmall, name: 'displaySmall'),
      DebugToolsTextStyle(textStyle: textTheme.headlineLarge, name: 'headlineLarge'),
      DebugToolsTextStyle(textStyle: textTheme.headlineMedium, name: 'headlineMedium'),
      DebugToolsTextStyle(textStyle: textTheme.headlineSmall, name: 'headlineSmall'),
      DebugToolsTextStyle(textStyle: textTheme.titleLarge, name: 'titleLarge'),
      DebugToolsTextStyle(textStyle: textTheme.titleMedium, name: 'titleMedium'),
      DebugToolsTextStyle(textStyle: textTheme.titleSmall, name: 'titleSmall'),
      DebugToolsTextStyle(textStyle: textTheme.bodyLarge, name: 'bodyLarge'),
      DebugToolsTextStyle(textStyle: textTheme.bodyMedium, name: 'bodyMedium'),
      DebugToolsTextStyle(textStyle: textTheme.bodySmall, name: 'bodySmall'),
      DebugToolsTextStyle(textStyle: textTheme.labelLarge, name: 'labelLarge'),
      DebugToolsTextStyle(textStyle: textTheme.labelMedium, name: 'labelMedium'),
      DebugToolsTextStyle(textStyle: textTheme.labelSmall, name: 'labelSmall'),
    ];
  }
}
