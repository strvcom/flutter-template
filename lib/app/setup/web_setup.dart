import 'package:flutter_app/app/setup/flavor.dart';
import 'package:universal_html/html.dart';

class WebSetup {
  WebSetup._();

  static void setup({required Flavor flavor}) {
    final script = ScriptElement();

    switch (flavor) {
      case Flavor.develop:
        script.id = 'develop';
        break;
      case Flavor.staging:
        script.id = 'staging';
        break;
      case Flavor.production:
        script.id = 'production';
        break;
    }

    document.head?.append(script);
  }
}
