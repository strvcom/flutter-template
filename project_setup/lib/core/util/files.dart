import 'dart:io';

import 'package:project_setup/core/util/print.dart';

Future<void> findAndReplaceTextInDirectory({
  required String directoryPath,
  required String searchString,
  required String replaceString,
  List<String>? excludedDirs,
  List<String>? includedFiles,
}) async {
  final directory = Directory.fromUri(Uri.parse(directoryPath));

  // List all entities (files and directories) in the current directory recursively
  await for (FileSystemEntity entity in directory.list(recursive: true, followLinks: false)) {
    // Check if the entity is a directory and if it's in the excludedDirs list
    if (entity is Directory) {
      if (excludedDirs != null && excludedDirs.contains(entity.path.split(Platform.pathSeparator).last)) {
        print('Skipping directory: ${entity.path}');
        continue;
      }
    }

    // Check if the entity is a file and if it's in the excludedFiles list
    if (entity is File) {
      if (includedFiles != null && includedFiles.contains(entity.path.split(Platform.pathSeparator).last)) {
        await findAndRemplaceTextInFile(
          file: entity,
          searchString: searchString,
          replaceString: replaceString,
        );
      }
      continue;
    }
  }
}

Future<void> findAndRemplaceTextInFile({
  required File file,
  required String searchString,
  required String replaceString,
}) async {
  try {
    // Read the file content
    String content = await file.readAsString();

    // Check if the file contains the search string
    if (content.contains(searchString)) {
      // Replace all occurrences of the search string with the replacement string
      content = content.replaceAll(searchString, replaceString);

      // Write the modified content back to the file
      await file.writeAsString(content);

      // Print a message indicating that the file was modified
      printBrightBlue('Modified file: ${file.path}');
    }
  } on Exception catch (e) {
    // Print an error message if an exception occurs
    printBoldRed('Error processing file ${file.path}: $e');
  }
}

Future<void> findAndReplaceDirectoryPath({
  required String directoryPath,
  required String oldStructure,
  required String newStructure,
  List<String>? excludedDirs,
}) async {
  final directory = Directory.fromUri(Uri.parse(directoryPath));
  final dirStillExists = await directory.exists();
  if (!dirStillExists) {
    return;
  }

  // List all entities (files and directories) in the current directory recursively
  await for (FileSystemEntity entity in directory.list(recursive: true, followLinks: false)) {
    // Check if the entity is a directory
    if (entity is Directory) {
      try {
        // Check if the entity is in the excludedDirs list
        if (excludedDirs != null && excludedDirs.contains(entity.path.split(Platform.pathSeparator).last)) {
          print('Skipping directory: ${entity.path}');
          continue;
        }

        await findAndReplaceDirectoryPath(directoryPath: entity.path, oldStructure: oldStructure, newStructure: newStructure);

        // Check if the directory path matches the old structure
        final dirStillExists = await entity.exists();
        if (entity.path.contains(oldStructure) && dirStillExists) {
          // Create the new directory path
          final newPath = entity.path.replaceFirst(oldStructure, newStructure);
          await Directory(newPath).create(recursive: true);
          await entity.rename(newPath);
          printBrightBlue('Renamed directory: ${entity.path} to $newPath');
        }
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        // Print an error message if an exception occurs
        printBoldRed('Error processing directory ${entity.path}: $e');
      }
    }
  }
}
