import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:interact/interact.dart';
import 'package:project_setup/configuration.dart';
import 'package:project_setup/core/model/setup_platform.dart';
import 'package:project_setup/core/util/print.dart';
import 'package:project_setup/core/util/util.dart';

Future<void> generateSplashScreen() async {
  printBoldCyan('Generating Splash Screen...');

  final progress = Progress(length: 5, size: 0.25, rightPrompt: (step) => ' $step / 5').interact();
  progress.increase(1);

  // Title: Step 1 - Generate config file
  final configFile = await _generateConfigFile();
  progress.increase(1);

  // Title: Step 2 - Generate image
  final splashImage = await _generateSplashImage();
  progress.increase(1);

  // Title: Step 3 - Run flutter_native_splash
  await Process.run(
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

  // Title: Step 4 - Cleanup the temporary files
  await configFile.delete();
  await splashImage.delete();

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
  File inputImageFile = File('${getSetupDirectoryPath()}/resources/splash.png');
  List<int> inputImageBytes = await inputImageFile.readAsBytes();
  Image inputImage = decodeImage(Uint8List.fromList(inputImageBytes))!;
  Image outputImage = Image(width: 1152, height: 1152, numChannels: 4);

  void _drawOverlayImage() {
    final offset = 1152 ~/ 2 - 768 ~/ 2;
    // Manually overlay the overlayImage onto the baseImage
    for (int y = 0; y < inputImage.height; y++) {
      for (int x = 0; x < inputImage.width; x++) {
        // Get the pixel color and alpha value
        Pixel pixel = inputImage.getPixel(x, y);
        num alpha = pixel.a;

        // If the pixel is fully transparent, fill it with the specified color
        if (alpha != 0) {
          outputImage.setPixel(x + offset, y + offset, pixel);
        }
      }
    }
  }

  Future<File> _saveImage(String fileName) async {
    File outputImageFile = File('${getSetupDirectoryPath()}/$fileName');
    await outputImageFile.writeAsBytes(encodePng(outputImage));
    return outputImageFile;
  }

  // Title: Generate Larger image (1152x1152 with image in center)
  _drawOverlayImage();

  return await _saveImage('tmp_splash.png');
}
