import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/custom_color_scheme.dart';
import 'package:flutter_app/app/theme/custom_text_theme.dart';

/// Class used to publicly expose themes.
///
/// If you want to expose more colors, styles and so on, you can create public
/// properties here in this class. In order to make code more readable, app theme
/// is separated to multiple files.
class AppTheme {
  AppTheme._();

  static ThemeData getThemeData({required Brightness brightness}) {
    final colorScheme = CustomColorScheme(brightness: brightness);
    final textTheme = CustomTextTheme(colorScheme: colorScheme);

    return ThemeData(
      brightness: brightness,
      colorScheme: (kDebugMode)
          ? _getUndefinedColorScheme(brightness)
          : ColorScheme.fromSeed(seedColor: colorScheme.primary, brightness: brightness),
      visualDensity: VisualDensity.standard, // Needed for consistent web and app sizing
      textTheme: (kDebugMode) ? _getUndefinedTextTheme() : null,
      scaffoldBackgroundColor: colorScheme.surface,
      // Warning: IconButtonTheme needs to be set till this is fixed: https://github.com/flutter/flutter/issues/130485
      iconButtonTheme: const IconButtonThemeData(style: ButtonStyle()),
      bottomSheetTheme: _getBottomSheetThemeData(colorScheme: colorScheme, textTheme: textTheme),
      scrollbarTheme: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(colorScheme.onSurface.withValues(alpha: 0.3))),
      // Warning: textSelectionTheme must be overwritten here.
      // Overriding theme only around TextField does not work for [selectionHandleColor]
      textSelectionTheme: _getTextSelectionThemeData(colorScheme: colorScheme),
      // This is hotfix that is needed to set correct color for [selectionHandleColor] on iOS.
      cupertinoOverrideTheme: CupertinoThemeData(primaryColor: colorScheme.secondary),
    );
  }

  static ColorScheme _getUndefinedColorScheme(Brightness brightness) {
    const undefined = Color(0xFFF700D5);
    return ColorScheme(
      brightness: brightness,
      primary: undefined,
      onPrimary: undefined,
      primaryContainer: undefined,
      onPrimaryContainer: undefined,
      secondary: undefined,
      onSecondary: undefined,
      secondaryContainer: undefined,
      onSecondaryContainer: undefined,
      tertiary: undefined,
      onTertiary: undefined,
      tertiaryContainer: undefined,
      onTertiaryContainer: undefined,
      error: undefined,
      onError: undefined,
      errorContainer: undefined,
      onErrorContainer: undefined,
      surface: undefined,
      onSurface: undefined,
      surfaceContainerHighest: undefined,
      onSurfaceVariant: undefined,
      outline: undefined,
      outlineVariant: undefined,
      shadow: undefined,
      scrim: undefined,
      inverseSurface: undefined,
      onInverseSurface: undefined,
      inversePrimary: undefined,
      surfaceTint: undefined,
    );
  }

  static TextTheme _getUndefinedTextTheme() {
    const undefined = Color(0xFFF700D5);
    const defaultTextStyle = TextStyle(
      color: undefined, // Text color
      decorationColor: undefined,
    );

    return const TextTheme(
      displayLarge: defaultTextStyle,
      displayMedium: defaultTextStyle,
      displaySmall: defaultTextStyle,
      headlineLarge: defaultTextStyle,
      headlineMedium: defaultTextStyle,
      headlineSmall: defaultTextStyle,
      titleLarge: defaultTextStyle,
      titleMedium: defaultTextStyle,
      titleSmall: defaultTextStyle,
      labelLarge: defaultTextStyle,
      labelMedium: defaultTextStyle,
      labelSmall: defaultTextStyle,
      bodyLarge: defaultTextStyle,
      bodyMedium: defaultTextStyle,
      bodySmall: defaultTextStyle,
    );
  }
}

BottomSheetThemeData _getBottomSheetThemeData({
  required CustomColorScheme colorScheme,
  required CustomTextTheme textTheme,
}) =>
    BottomSheetThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
    );

TextSelectionThemeData _getTextSelectionThemeData({
  required CustomColorScheme colorScheme,
}) =>
    TextSelectionThemeData(
      cursorColor: colorScheme.secondary,
      selectionColor: colorScheme.secondary.withValues(alpha: 0.3),
      selectionHandleColor: colorScheme.secondary,
    );
