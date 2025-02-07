import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/extension/brightness.dart';
import 'package:flutter_app/core/database/shared_preferences.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_app/core/riverpod/state_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier with StateHandler {
  @override
  FutureOr<ThemeMode> build() async {
    return await _getThemeMode();
  }

  Future<ThemeMode> _getThemeMode() async {
    try {
      final preferences = await ref.read(sharedPreferencesProvider.future);
      final themeMode = preferences.getString(PreferencesKeys.themeMode.value);
      if (themeMode == null) return ThemeMode.system;
      Flogger.i('[ThemeModeNotifier] Theme mode restored $themeMode');
      return ThemeMode.values.firstWhereOrNull((element) => element.name == themeMode) ?? ThemeMode.system;
    } on Exception catch (error, st) {
      Flogger.e('[ThemeModeNotifier] Get failed due to $error', exception: error, stackTrace: st);
      return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final preferences = await ref.read(sharedPreferencesProvider.future);
      await preferences.setString(PreferencesKeys.themeMode.value, themeMode.name);
      Flogger.i('[ThemeModeNotifier] Theme Mode saved $themeMode');
      setStateData(themeMode);
    } on Exception catch (error, st) {
      Flogger.e('[ThemeModeNotifier] Save failed due to $error', exception: error, stackTrace: st);
    }
  }

  bool isLightMode() {
    final brightness = PlatformDispatcher.instance.platformBrightness;
    return currentData == ThemeMode.light || (currentData == ThemeMode.system && brightness.isLightMode);
  }

  Brightness get brightness => isLightMode() ? Brightness.light : Brightness.dark;
}
