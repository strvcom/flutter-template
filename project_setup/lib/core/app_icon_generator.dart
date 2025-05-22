import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:interact/interact.dart';
import 'package:project_setup/configuration.dart';
import 'package:project_setup/core/model/app_icon_variant_model.dart';
import 'package:project_setup/core/model/setup_platform.dart';
import 'package:project_setup/core/util/print.dart';
import 'package:project_setup/core/util/util.dart';

Future<void> generateAppIcons() async {
  printBoldCyan('Generating App Icons...');

  final progress = Progress(
    length: Configuration.appIconVariants.length * 2,
    size: 0.25,
    rightPrompt: (step) => ' $step / ${Configuration.appIconVariants.length * 2}',
  ).interact();
  progress.increase(1);

  for (final appIconVariant in Configuration.appIconVariants) {
    // Title: Step 1 - Generate config file for variant
    final iconsLauncherConfigFile = await _generateConfigFile(appIconVariant: appIconVariant);

    // Title: Step 2 - Generate icon for variant
    final icons = await _generateIcons(
      labelColorHex: appIconVariant.labelColorHex,
      labelText: appIconVariant.labelText,
      displayDebugIndicator: appIconVariant.debugIndicator,
      iconShouldOverlayLabel: appIconVariant.iconShouldOverlayLabel,
    );

    progress.increase(1);

    // Title: Step 3 - Run icons_launcher
    await Process.run(
      'fvm',
      [
        'dart',
        'pub',
        'global',
        'run',
        'icons_launcher:create',
        '--flavor',
        '${appIconVariant.name}',
        '--path',
        '${getSetupDirectoryPath()}/tmp_icons_launcher_config.yaml',
      ],
      workingDirectory: getProjectRootDirectoryPath(),
    );

    // Title: Step 4 - Cleanup the temporary files
    await iconsLauncherConfigFile.delete();
    for (final icon in icons) {
      await icon.delete();
    }

    progress.increase(1);
  }

  // Finish
  progress.done();
  printBoldGreen('✅ App Icons generated successfully!');
}

Future<File> _generateConfigFile({required AppIconVariantModel appIconVariant}) async {
  final iconsLauncherConfigFile = File('${getSetupDirectoryPath()}/tmp_icons_launcher_config.yaml');
  await iconsLauncherConfigFile.writeAsString('''
icons_launcher:
  image_path: "project_setup/tmp_app_icon_cropped.png"

  platforms:
    android:
      enable: ${appIconVariant.platforms.contains(SetupPlatform.android) ? "true" : "false"}
      image_path: "project_setup/tmp_app_icon_android.png"
      adaptive_background_color: "${Configuration.appIconBackgroundColor}"
      adaptive_foreground_image: "project_setup/tmp_app_icon_android_foreground.png"
      
    ios:
      enable: ${appIconVariant.platforms.contains(SetupPlatform.ios) ? "true" : "false"}

    web:
      enable: ${appIconVariant.platforms.contains(SetupPlatform.web) ? "true" : "false"}

    macos:
      enable: ${appIconVariant.platforms.contains(SetupPlatform.macos) ? "true" : "false"}

    linux:
      enable: ${appIconVariant.platforms.contains(SetupPlatform.linux) ? "true" : "false"}
 
    windows:
      enable: ${appIconVariant.platforms.contains(SetupPlatform.windows) ? "true" : "false"}
''');
  return iconsLauncherConfigFile;
}

/// We need to generate three files that are used inside the config file:
///   - tmp_app_icon_cropped.png
///   - tmp_app_icon_android.png
///   - tmp_app_icon_android_foreground.png
///
/// Input Icon should be 900x900 which will be generated into 1500x1500 icon for Android usage
/// Generated Cropped icon should be 1024x1024 which is used for iOS
Future<List<File>> _generateIcons({
  required String? labelColorHex,
  required String? labelText,
  required bool displayDebugIndicator,
  required bool iconShouldOverlayLabel,
}) async {
  // Load the input image file
  File inputImageFile = File('${getSetupDirectoryPath()}/resources/icon.png');
  File fontFile = File('${getSetupDirectoryPath()}/resources/exo_bold.zip');
  List<int> inputImageBytes = await inputImageFile.readAsBytes();
  Image inputImage = decodeImage(Uint8List.fromList(inputImageBytes))!;
  Image outputImage = Image(width: 1500, height: 1500, numChannels: 4);
  final font = BitmapFont.fromZip(await fontFile.readAsBytes());

  void _drawLabel() {
    // Draw label rectangle
    drawLine(outputImage, x1: 0, y1: 1240, x2: 1500, y2: 1240, color: colorFromHex(labelColorHex!), thickness: 530);

    // Draw label text
    drawString(
      outputImage,
      labelText!,
      font: font,
      y: 980,
      color: ColorFloat32.rgb(255, 255, 255),
    );

    // Draw debug indicator
    if (displayDebugIndicator) {
      fillCircle(
        outputImage,
        radius: 60,
        x: 1075,
        y: 975,
        // 1075,975 1135,975
        color: ColorFloat32.rgb(255, 0, 0),
      );
    }
  }

  void _drawOverlayImage() {
    final widthOffset = 1500 ~/ 2 - inputImage.width ~/ 2;
    final heightOffset = 1500 ~/ 2 - inputImage.height ~/ 2;
    // Manually overlay the overlayImage onto the baseImage
    for (int y = 0; y < inputImage.height; y++) {
      for (int x = 0; x < inputImage.width; x++) {
        // Get the pixel color and alpha value
        Pixel pixel = inputImage.getPixel(x, y);
        num alpha = pixel.a;

        // If the pixel is fully transparent, fill it with the specified color
        if (alpha != 0) {
          outputImage.setPixel(x + widthOffset, y + heightOffset, pixel);
        }
      }
    }
  }

  Future<File> _saveImage(String fileName) async {
    File outputImageFile = File('${getSetupDirectoryPath()}/$fileName');
    await outputImageFile.writeAsBytes(encodePng(outputImage));
    return outputImageFile;
  }

  // Title: Step 1 - Generate Android Foreground image (1500x1500 - transparent background)
  if (!iconShouldOverlayLabel) _drawOverlayImage();
  if (labelColorHex != null && labelText != null) _drawLabel();
  if (iconShouldOverlayLabel) _drawOverlayImage();

  final androidForegroundFile = await _saveImage('tmp_app_icon_android_foreground.png');

  // Title: Step 2 - Generate Android image (1500x1500 - filled background)
  fill(outputImage, color: colorFromHex(Configuration.appIconBackgroundColor));
  if (!iconShouldOverlayLabel) _drawOverlayImage();
  if (labelColorHex != null && labelText != null) _drawLabel();
  if (iconShouldOverlayLabel) _drawOverlayImage();

  final androidFile = await _saveImage('tmp_app_icon_android.png');

  // Title: Step 3 - Generate Cropped image (1024x1024 - filled background)
  int space = (1500 - 1024) ~/ 2;
  outputImage = copyCrop(outputImage, x: space, y: space, width: 1024, height: 1024);

  final croppedFile = await _saveImage('tmp_app_icon_cropped.png');

  return [androidForegroundFile, androidFile, croppedFile];
}
