import 'package:flutter/material.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class CustomTimePicker {
  CustomTimePicker({
    required this.context,
    required this.initialTime,
  });

  final BuildContext context;
  final TimeOfDay initialTime;

  Future<TimeOfDay?> show() async {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) => Theme(
        data: context.theme.copyWith(
          colorScheme: context.theme.colorScheme.copyWith(
            shadow: context.colorScheme.shadow,
            surface: context.colorScheme.surface,
            error: context.colorScheme.error,
            onSurface: context.colorScheme.onSurface,
            primary: context.colorScheme.primary,
            onSurfaceVariant: context.colorScheme.onSurface,
            outline: context.colorScheme.onSurface.withValues(alpha: 0.9),
            outlineVariant: context.colorScheme.divider,
          ),
          textTheme: context.theme.textTheme.copyWith(
            bodyLarge: context.textTheme.bodyMedium, // For Input text
            bodySmall: context.textTheme.bodySmall, // For Note under input
          ),
        ),
        // Wrapping in MediaQuery to always display 24h time format picker. This can be removed, if 12h format is needed.
        child: TimePickerTheme(
          data: _getTimePickerThemeData(context),
          child: MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
        ),
      ),
    );
  }

  TimePickerThemeData _getTimePickerThemeData(BuildContext context) {
    return TimePickerThemeData(
      backgroundColor: context.colorScheme.surface,
      entryModeIconColor: context.colorScheme.onSurface,
      helpTextStyle: TextStyle(fontSize: 16, color: context.colorScheme.onSurface),
      timeSelectorSeparatorTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 50, color: context.colorScheme.primary)),
      timeSelectorSeparatorColor: WidgetStatePropertyAll(context.colorScheme.onSurface),
      dayPeriodBorderSide: BorderSide(color: context.colorScheme.onSurface.withValues(alpha: 0.1)),
      dayPeriodTextColor: context.colorScheme.onSurface,
      dayPeriodColor: context.colorScheme.primary.withValues(alpha: 0.1),
      dayPeriodShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      dayPeriodTextStyle: TextStyle(fontSize: 16, color: context.colorScheme.onSurface),
      hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      hourMinuteTextStyle: TextStyle(fontSize: 50, color: context.colorScheme.onSurface),
      hourMinuteColor: context.colorScheme.onSurface.withValues(alpha: 0.1),
      hourMinuteTextColor: context.colorScheme.onSurface,
      dialTextStyle: context.textTheme.bodySmall,
      dialTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return context.colorScheme.onPrimary;
        }
        return context.colorScheme.onSurface;
      }),
      dialHandColor: context.colorScheme.primary,
      dialBackgroundColor: context.colorScheme.onSurface.withValues(alpha: 0.1),
      confirmButtonStyle: TextButton.styleFrom(foregroundColor: context.colorScheme.primary),
      cancelButtonStyle: TextButton.styleFrom(foregroundColor: context.colorScheme.onSurface.withValues(alpha: 0.5)),
    );
  }
}
