import 'package:flutter/material.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class CustomDatePicker {
  CustomDatePicker({
    required this.context,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    this.currentDate,
  });

  final BuildContext context;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialDate;
  final DateTime? currentDate;

  Future<DateTime?> show() async {
    return showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: initialDate,
      currentDate: currentDate ?? DateTime.now(),
      builder: (context, child) => Theme(
        data: context.theme.copyWith(
          colorScheme: context.theme.colorScheme.copyWith(
            shadow: context.colorScheme.shadow,
            surface: context.colorScheme.surface,
            error: context.colorScheme.error,
            onSurface: context.colorScheme.onSurface,
            primary: context.colorScheme.primary,
            onSurfaceVariant: context.colorScheme.onSurface,
            outline: context.colorScheme.primary.withValues(alpha: 0.9),
            outlineVariant: context.colorScheme.divider,
          ),
          textTheme: context.theme.textTheme.copyWith(
            bodyLarge: context.textTheme.bodyMedium, // For Input text
          ),
        ),
        child: DatePickerTheme(
          data: _getTimePickerThemeData(context),
          child: child!,
        ),
      ),
    );
  }

  DatePickerThemeData _getTimePickerThemeData(BuildContext context) {
    final universalTextBackgroundColor = WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return context.colorScheme.primary;
      }
      return context.colorScheme.surface;
    });

    final universalTextForegroundColor = WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return context.colorScheme.onPrimary;
      } else if (states.contains(WidgetState.disabled)) {
        return context.colorScheme.onSurface.withValues(alpha: 0.38);
      }
      return context.colorScheme.onSurface;
    });

    // Add your custom theme data here
    return DatePickerThemeData(
      backgroundColor: context.colorScheme.surface,
      dividerColor: context.colorScheme.divider,
      headerBackgroundColor: context.colorScheme.surface,
      headerForegroundColor: context.colorScheme.onSurface,
      headerHeadlineStyle: context.textTheme.bodyMedium.copyWith(color: context.colorScheme.onSurface),
      headerHelpStyle: context.textTheme.bodyMedium.copyWith(color: context.colorScheme.onSurface),
      surfaceTintColor: Colors.transparent,
      yearOverlayColor: WidgetStatePropertyAll(context.colorScheme.primary.withValues(alpha: 0.1)),
      dayOverlayColor: WidgetStatePropertyAll(context.colorScheme.primary.withValues(alpha: 0.1)),
      yearStyle: context.textTheme.bodyMedium.copyWith(color: context.colorScheme.primary),
      dayStyle: context.textTheme.bodyMedium.copyWith(color: context.colorScheme.primary),
      weekdayStyle: context.textTheme.bodyMedium.copyWith(color: context.colorScheme.primary),
      yearBackgroundColor: universalTextBackgroundColor,
      yearForegroundColor: universalTextForegroundColor,
      dayBackgroundColor: universalTextBackgroundColor,
      dayForegroundColor: universalTextForegroundColor,
      todayBackgroundColor: universalTextBackgroundColor,
      todayForegroundColor: universalTextForegroundColor,
      confirmButtonStyle: TextButton.styleFrom(foregroundColor: context.colorScheme.primary),
      cancelButtonStyle: TextButton.styleFrom(foregroundColor: context.colorScheme.onSurface.withValues(alpha: 0.5)),
    );
  }
}
