import 'dart:io';

import 'package:image/image.dart';

String getSetupDirectoryPath() {
  return Directory.current.path + '/project_setup';
}

String getProjectRootDirectoryPath() {
  return Directory.current.path;
}

Color colorFromHex(String hexString) {
  // Remove the hash sign if it exists
  hexString = hexString.replaceFirst('#', '');

  // Parse the hex string to get integer values for red, green, and blue
  int hexColor = int.parse(hexString, radix: 16);
  double red = ((hexColor >> 16) & 0xFF) / 255.0;
  double green = ((hexColor >> 8) & 0xFF) / 255.0;
  double blue = (hexColor & 0xFF) / 255.0;

  // If the hex string contains alpha (8 characters), parse it
  double alpha = 1.0;
  if (hexString.length == 8) {
    alpha = ((hexColor >> 24) & 0xFF) / 255.0;
  }

  return ColorFloat32.rgba(red, green, blue, alpha);
}
