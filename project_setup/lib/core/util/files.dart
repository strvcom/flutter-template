import 'dart:io';

import 'package:project_setup/core/util/print.dart';

Future<void> findAndReplaceTextInDirectory({
  required String directoryPath,
  required String searchString,
  required String replaceString,
  List<String>? excludedDirs,
  List<String>? includedFiles,
}) async {
  final directory = Directory(directoryPath);

  await _findAndReplaceTextInDirectory(
    directory: directory,
    searchString: searchString,
    replaceString: replaceString,
    excludedDirs: excludedDirs,
    includedFiles: includedFiles,
  );
}

Future<void> _findAndReplaceTextInDirectory({
  required Directory directory,
  required String searchString,
  required String replaceString,
  List<String>? excludedDirs,
  List<String>? includedFiles,
}) async {
  await for (final entity in directory.list(followLinks: false)) {
    if (entity is Directory) {
      if (_isExcludedDirectory(entity, excludedDirs)) {
        print('Skipping directory: ${entity.path}');
        continue;
      }

      await _findAndReplaceTextInDirectory(
        directory: entity,
        searchString: searchString,
        replaceString: replaceString,
        excludedDirs: excludedDirs,
        includedFiles: includedFiles,
      );
      continue;
    }

    if (entity is File) {
      if (includedFiles != null && includedFiles.contains(entity.path.split(Platform.pathSeparator).last)) {
        await findAndReplaceTextInFile(
          file: entity,
          searchString: searchString,
          replaceString: replaceString,
        );
      }
      continue;
    }
  }
}

Future<void> findAndReplaceTextInFile({
  required File file,
  required String searchString,
  required String replaceString,
}) async {
  try {
    // Read the file content
    var content = await file.readAsString();

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
  final directory = Directory(directoryPath);
  final dirStillExists = await directory.exists();
  if (!dirStillExists) {
    return;
  }

  final normalizedOldStructure = oldStructure.replaceAll('/', Platform.pathSeparator);
  final normalizedNewStructure = newStructure.replaceAll('/', Platform.pathSeparator);
  final matchingDirectories = <Directory>[];

  await _collectMatchingDirectories(
    directory: directory,
    normalizedOldStructure: normalizedOldStructure,
    excludedDirs: excludedDirs,
    matchingDirectories: matchingDirectories,
  );

  matchingDirectories.sort((a, b) => b.path.length.compareTo(a.path.length));

  for (final entity in matchingDirectories) {
    try {
      if (!await entity.exists()) {
        continue;
      }

      final newPath = entity.path.replaceFirst(normalizedOldStructure, normalizedNewStructure);
      await Directory(newPath).parent.create(recursive: true);
      await entity.rename(newPath);
      printBrightBlue('Renamed directory: ${entity.path} to $newPath');
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      printBoldRed('Error processing directory ${entity.path}: $e');
    }
  }
}

Future<void> _collectMatchingDirectories({
  required Directory directory,
  required String normalizedOldStructure,
  required List<Directory> matchingDirectories,
  List<String>? excludedDirs,
}) async {
  await for (final entity in directory.list(followLinks: false)) {
    if (entity is! Directory) {
      continue;
    }

    if (_isExcludedDirectory(entity, excludedDirs)) {
      print('Skipping directory: ${entity.path}');
      continue;
    }

    if (entity.path.contains(normalizedOldStructure)) {
      matchingDirectories.add(entity);
    }

    await _collectMatchingDirectories(
      directory: entity,
      normalizedOldStructure: normalizedOldStructure,
      excludedDirs: excludedDirs,
      matchingDirectories: matchingDirectories,
    );
  }
}

bool _isExcludedDirectory(Directory directory, List<String>? excludedDirs) {
  if (excludedDirs == null) {
    return false;
  }

  return excludedDirs.contains(directory.path.split(Platform.pathSeparator).last);
}
