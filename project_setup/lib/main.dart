// ignore_for_file: avoid_print

/// You can build this as executable file using the following command:
///   dart compile exe setup.dart -o run-linux

import 'dart:io';

import 'package:interact/interact.dart';
import 'package:project_setup/core/app_icon_generator.dart';
import 'package:project_setup/core/app_rename.dart';
import 'package:project_setup/core/splash_screen_generator.dart';
import 'package:project_setup/core/util/print.dart';

void main() async {
  printBoldCyan('┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓');
  printBoldCyan('┃            Project Setup Tool v1.0            ┃');
  printBoldCyan('┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛');

  await _displaySetupOptions();
}

Future<void> _displaySetupOptions() async {
  printBoldCyan('');
  printBoldCyan('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  final setupOptions = ['Generate App Icons', 'Generate Splash Screen', 'Rename', 'Exit'];
  final selection = Select(
    prompt: 'What would you like to do?',
    options: setupOptions,
  ).interact();

  if (selection == 0) {
    await generateAppIcons();
    _displaySetupOptions();
  } else if (selection == 1) {
    await generateSplashScreen();
    _displaySetupOptions();
  } else if (selection == 2) {
    await appRename();
    _displaySetupOptions();
  } else {
    print('Exiting...');
    exit(0);
  }
}
