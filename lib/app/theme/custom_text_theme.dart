import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/custom_color_scheme.dart';
import 'package:flutter_app/assets/fonts.gen.dart';

/// All text themes are defined here. These themes will be usually passed into CustomText widget.
///
/// You can easily define all text styles like `letterSpacing` or `height` here.
/// Height should be computed as Figma `line height` / `font size`.
///
/// For example:
///  `letterSpacing: 0.5,`
///  `height: 40 / 32,`
///
/// In case of using font with variable weight support, use:
///   `fontVariations: const [FontVariation('wght', 400)],`
/// instead of:
///   `fontWeight: FontWeight.w400,`
///
class CustomTextTheme {
  CustomTextTheme({required CustomColorScheme colorScheme})
      : // Subtitle: Display
        displayLarge = TextStyle(
          fontSize: 57,
          fontFamily: FontFamily.clashDisplay,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        ),
        displayMedium = TextStyle(
          fontSize: 45,
          fontFamily: FontFamily.clashDisplay,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        ),
        displaySmall = TextStyle(
          fontSize: 36,
          fontFamily: FontFamily.clashDisplay,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        ),
        // Subtitle: Headline
        headlineLarge = TextStyle(
          fontSize: 32,
          fontFamily: FontFamily.clashDisplay,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        ),
        headlineMedium = TextStyle(
          fontSize: 28,
          fontFamily: FontFamily.clashDisplay,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        ),
        headlineSmall = TextStyle(
          fontSize: 24,
          fontFamily: FontFamily.clashDisplay,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        ),
        // Subtitle: Title
        titleLarge = TextStyle(
          fontSize: 22,
          fontFamily: FontFamily.clashDisplay,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        ),
        titleMedium = TextStyle(
          fontSize: 16,
          fontFamily: FontFamily.clashDisplay,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        ),
        titleSmall = TextStyle(
          fontSize: 14,
          fontFamily: FontFamily.clashDisplay,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        ),
        // Subtitle: Label
        labelLarge = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        ),
        labelMedium = TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        ),
        labelSmall = TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        ),
        // Subtitle: Body
        bodyLarge = TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        ),
        bodyMedium = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        ),
        bodySmall = TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface, // Used for autofill, suggestion underline, etc.
        );

  // Title: Theme specific TextStyles

  // Subtitle: Display
  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;

  // Subtitle: Headline
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;

  // Subtitle: Title
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;

  // Subtitle: Label
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  // Subtitle: Body
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
}
