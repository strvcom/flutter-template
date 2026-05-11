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
  while (true) {
    printBoldCyan('');
    printBoldCyan('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    final setupOptions = ['Generate App Icons', 'Generate Splash Screen', 'Rename', 'Exit'];
    final selection = Select(
      prompt: 'What would you like to do?',
      options: setupOptions,
    ).interact();

    if (selection == 0) {
      await generateAppIcons();
    } else if (selection == 1) {
      await generateSplashScreen();
    } else if (selection == 2) {
      await appRename();
    } else {
      print('Exiting...');
      return;
    }
  }
}
