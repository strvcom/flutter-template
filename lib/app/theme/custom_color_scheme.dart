import 'package:flutter/material.dart';
import 'package:flutter_app/common/extension/brightness.dart';

class CustomColorScheme {
  factory CustomColorScheme({required Brightness brightness}) =>
      (brightness.isLightMode) ? CustomColorScheme._light() : CustomColorScheme._dark();

  CustomColorScheme._light()
    : brightness = Brightness.light,
      primary = const Color(0xFF0A59F8),
      onPrimary = const Color(0xFFFFFFFF),
      secondary = const Color(0xFF000000),
      onSecondary = const Color(0xFFFFFFFF),
      surface = const Color(0xFFFFFFFF),
      surfaceVariant = const Color(0xFFF7F7F7),
      onSurface = const Color(0xFF000000),
      snackbarBackground = const Color(0xFF041028),
      snackbarText = const Color(0xFFFFFFFF),
      success = const Color(0xFF10B452),
      error = const Color(0xFFE51934),
      shadow = const Color(0x66000000),
      divider = const Color(0xFFEBEBEB),
      shimmerBackground = const Color(0xFFF0F0F0),
      shimmerForeground = const Color(0xFFF7F7F7);

  CustomColorScheme._dark()
    : brightness = Brightness.dark,
      primary = const Color(0xFF0A59F8),
      onPrimary = const Color(0xFFFFFFFF),
      secondary = const Color(0xFFFFFFFF),
      onSecondary = const Color(0xFF000000),
      surface = const Color(0xFF000000),
      surfaceVariant = const Color(0x1AFFFFFF),
      onSurface = const Color(0xFFFFFFFF),
      snackbarBackground = const Color(0xFF041028),
      snackbarText = const Color(0xFFFFFFFF),
      success = const Color(0xFF10B452),
      error = const Color(0xFFE51934),
      shadow = const Color(0x66000000),
      divider = const Color(0xFFEBEBEB),
      shimmerBackground = const Color(0xFF1F1F1F),
      shimmerForeground = const Color(0x1AFFFFFF);

  // Title: Theme specific colors
  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color surface;
  final Color surfaceVariant;
  final Color onSurface;
  final Color snackbarBackground;
  final Color snackbarText;
  final Color success;
  final Color error;
  final Color shadow;
  final Color divider;
  final Color shimmerBackground;
  final Color shimmerForeground;
}
