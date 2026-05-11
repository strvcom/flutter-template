import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:interact/interact.dart';
import 'package:project_setup/configuration.dart';
import 'package:project_setup/core/entity/setup_platform.dart';
import 'package:project_setup/core/util/print.dart';
import 'package:project_setup/core/util/process.dart';
import 'package:project_setup/core/util/util.dart';

Future<void> generateSplashScreen() async {
  printBoldCyan('Generating Splash Screen...');

  final progress = Progress(length: 5, size: 0.25, rightPrompt: (step) => ' $step / 5').interact();
  progress.increase(1);

  File? configFile;
  File? splashImage;
  try {
    // Title: Step 1 - Generate config file
    configFile = await _generateConfigFile();
    progress.increase(1);

    // Title: Step 2 - Generate image
    splashImage = await _generateSplashImage();
    progress.increase(1);

    // Title: Step 3 - Run flutter_native_splash
    await runRequiredProcess(
      'fvm',
      [
        'dart',
        'pub',
        'run',
        'flutter_native_splash:create',
        '--path',
        '${getSetupDirectoryPath()}/tmp_splash_screen_config.yaml',
      ],
      workingDirectory: getProjectRootDirectoryPath(),
    );
    progress.increase(1);
  } finally {
    // Title: Step 4 - Cleanup the temporary files
    if (configFile != null && await configFile.exists()) {
      await configFile.delete();
    }
    if (splashImage != null && await splashImage.exists()) {
      await splashImage.delete();
    }
  }

  progress.increase(1);

  // Finish
  progress.done();
  printBoldGreen('✅ Splash Screen generated successfully!');
}

Future<File> _generateConfigFile() async {
  final iconsLauncherConfigFile = File('${getSetupDirectoryPath()}/tmp_splash_screen_config.yaml');
  await iconsLauncherConfigFile.writeAsString('''
flutter_native_splash:
  android: ${Configuration.splashScreenPlatforms.contains(SetupPlatform.android) ? "true" : "false"}
  ios: ${Configuration.splashScreenPlatforms.contains(SetupPlatform.ios) ? "true" : "false"}
  web: ${Configuration.splashScreenPlatforms.contains(SetupPlatform.web) ? "true" : "false"}
  fullscreen: true
  color: "${Configuration.splashScreenBackgroundColor}"
  color_dark: "${Configuration.splashScreenDarkModeBackgroundColor}"
  image: "project_setup/tmp_splash.png"
  android_12:
    color: "${Configuration.splashScreenBackgroundColor}"
    color_dark: "${Configuration.splashScreenDarkModeBackgroundColor}"
    image: "project_setup/tmp_splash.png"
''');
  return iconsLauncherConfigFile;
}

/// We need to generate image that is used inside the config file:
///   - tmp_splash.png
///
/// Input Icon should be 768x768 which will be generated into 1152x1152 image.
/// Warning: The image must fit in a circle shape!!!
Future<File> _generateSplashImage() async {
  // Load the input image file
  final inputImageFile = File('${getSetupDirectoryPath()}/resources/splash.png');
  final inputImageBytes = await inputImageFile.readAsBytes();
  final inputImage = decodeImage(Uint8List.fromList(inputImageBytes));
  if (inputImage == null) {
    throw StateError('Could not decode ${inputImageFile.path}.');
  }
  if (inputImage.width != 768 || inputImage.height != 768) {
    throw StateError('Expected ${inputImageFile.path} to be 768x768, got ${inputImage.width}x${inputImage.height}.');
  }

  final outputImage = Image(width: 1152, height: 1152, numChannels: 4);

  void drawOverlayImage() {
    const offset = 1152 ~/ 2 - 768 ~/ 2;
    // Manually overlay the overlayImage onto the baseImage
    for (var y = 0; y < inputImage.height; y++) {
      for (var x = 0; x < inputImage.width; x++) {
        // Get the pixel color and alpha value
        final pixel = inputImage.getPixel(x, y);
        final alpha = pixel.a;

        // If the pixel is fully transparent, fill it with the specified color
        if (alpha != 0) {
          outputImage.setPixel(x + offset, y + offset, pixel);
        }
      }
    }
  }

  Future<File> saveImage(String fileName) async {
    final outputImageFile = File('${getSetupDirectoryPath()}/$fileName');
    await outputImageFile.writeAsBytes(encodePng(outputImage));
    return outputImageFile;
  }

  // Title: Generate Larger image (1152x1152 with image in center)
  drawOverlayImage();

  return saveImage('tmp_splash.png');
}
