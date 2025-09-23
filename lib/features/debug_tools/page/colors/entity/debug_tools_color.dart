import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/custom_color_scheme.dart';

@immutable
class DebugToolsColor {
  const DebugToolsColor({
    required this.colorName,
    required this.color,
  });

  final String colorName;
  final Color color;

  static List<DebugToolsColor> getColors({required Brightness brightness}) {
    final colorScheme = CustomColorScheme(brightness: brightness);

    return [
      DebugToolsColor(color: colorScheme.primary, colorName: 'primary'),
      DebugToolsColor(color: colorScheme.onPrimary, colorName: 'onPrimary'),
      DebugToolsColor(color: colorScheme.secondary, colorName: 'secondary'),
      DebugToolsColor(color: colorScheme.onSecondary, colorName: 'onSecondary'),
      DebugToolsColor(color: colorScheme.surface, colorName: 'surface'),
      DebugToolsColor(color: colorScheme.onSurface, colorName: 'onSurface'),
      DebugToolsColor(color: colorScheme.snackbarBackground, colorName: 'snackbarBackground'),
      DebugToolsColor(color: colorScheme.snackbarText, colorName: 'snackbarText'),
      DebugToolsColor(color: colorScheme.success, colorName: 'success'),
      DebugToolsColor(color: colorScheme.error, colorName: 'error'),
      DebugToolsColor(color: colorScheme.shadow, colorName: 'shadow'),
      DebugToolsColor(color: colorScheme.divider, colorName: 'divider'),
    ];
  }
}
