import 'dart:io';

import 'package:image/image.dart';

String getSetupDirectoryPath() {
  return '${getProjectRootDirectoryPath()}${Platform.pathSeparator}project_setup';
}

String getProjectRootDirectoryPath() {
  final currentDirectory = Directory.current;
  final currentPath = currentDirectory.path;

  if (Directory('$currentPath${Platform.pathSeparator}project_setup').existsSync()) {
    return currentPath;
  }

  final pathSegments = currentDirectory.uri.pathSegments.where((segment) => segment.isNotEmpty).toList();
  if (pathSegments.isNotEmpty && pathSegments.last == 'project_setup') {
    return currentDirectory.parent.path;
  }

  return currentPath;
}

Color colorFromHex(String hexString) {
  final normalizedHexString = hexString.replaceFirst('#', '');
  final isValidHexColor = RegExp(r'^[0-9a-fA-F]{6}([0-9a-fA-F]{2})?$').hasMatch(normalizedHexString);
  if (!isValidHexColor) {
    throw FormatException('Expected a 6 or 8 character hex color value, got "$hexString".');
  }

  // Parse the hex string to get integer values for red, green, and blue
  final hexColor = int.parse(normalizedHexString, radix: 16);
  final red = ((hexColor >> 16) & 0xFF) / 255.0;
  final green = ((hexColor >> 8) & 0xFF) / 255.0;
  final blue = (hexColor & 0xFF) / 255.0;

  // If the hex string contains alpha (8 characters), parse it
  var alpha = 1.0;
  if (normalizedHexString.length == 8) {
    alpha = ((hexColor >> 24) & 0xFF) / 255.0;
  }

  return ColorFloat32.rgba(red, green, blue, alpha);
}
