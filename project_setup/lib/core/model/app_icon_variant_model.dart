import 'package:project_setup/core/model/setup_platform.dart';

class AppIconVariantModel {
  const AppIconVariantModel({
    required this.name,
    this.labelColorHex = null,
    this.labelText = null,
    this.debugIndicator = false,
    this.iconShouldOverlayLabel = false,
    this.platforms = const [SetupPlatform.android, SetupPlatform.ios],
  });

  final String name;
  final String? labelColorHex;
  final String? labelText;
  final bool debugIndicator;
  final bool iconShouldOverlayLabel;
  final List<SetupPlatform> platforms;
}
