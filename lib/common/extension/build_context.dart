import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/custom_color_scheme.dart';
import 'package:flutter_app/app/theme/custom_text_theme.dart';
import 'package:flutter_app/assets/app_localizations.gen.dart';

extension BuildContextExtension on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this)!;
  ThemeData get theme => Theme.of(this);
  CustomColorScheme get colorScheme => CustomColorScheme(brightness: Theme.of(this).colorScheme.brightness);
  CustomTextTheme get textTheme => CustomTextTheme(colorScheme: colorScheme);
}
