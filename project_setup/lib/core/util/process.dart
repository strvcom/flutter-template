import 'dart:io';

import 'package:project_setup/core/util/print.dart';

Future<void> runRequiredProcess(
  String executable,
  List<String> arguments, {
  required String workingDirectory,
}) async {
  final result = await Process.run(
    executable,
    arguments,
    workingDirectory: workingDirectory,
  );

  if (result.exitCode == 0) {
    _printProcessOutput(result.stdout);
    return;
  }

  printBoldRed('Command failed with exit code ${result.exitCode}: $executable ${arguments.join(' ')}');
  _printProcessOutput(result.stdout);
  _printProcessOutput(result.stderr);

  throw ProcessException(
    executable,
    arguments,
    result.stderr.toString(),
    result.exitCode,
  );
}

void _printProcessOutput(Object? output) {
  final outputText = output?.toString().trim();
  if (outputText == null || outputText.isEmpty) {
    return;
  }

  print(outputText);
}
