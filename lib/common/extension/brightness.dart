import 'package:flutter/material.dart';

extension BrightnessExtension on Brightness {
  Brightness get inverse {
    return (this == Brightness.light) ? Brightness.dark : Brightness.light;
  }

  bool get isLightMode {
    return this == Brightness.light;
  }
}
