import 'package:flutter_app/app/app.dart';
import 'package:flutter_app/app/setup/flavor.dart';
import 'package:flutter_app/app/setup/setup_app.dart';

void main() async {
  await setupApp(flavor: Flavor.staging);
  App.startApp();
}
