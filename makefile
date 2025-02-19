# https://medium.com/flutter-community/automating-flutter-workflows-with-the-makefile-423b8e023c9a
.PHONY: setup build_runner clean gen gen_locale install integration_test test generateAndroidProductionAppBundle generateIosStagingIpa generateIosProductionIpa generateWebProduction deployWeb runner_gen

setup: # Setup the project
	@fvm dart ./project_setup/lib/main.dart

build_runner: # Run build_runner
	@fvm dart run build_runner watch --delete-conflicting-outputs

clean: # Clean everything in the project, download dependencies, generate code
	@rm ios/Podfile.lock || true
	@fvm flutter clean
	@fvm flutter pub get
	@make gen

gen: # Generates localization and freezed files in project
	@make gen_locale
	@fvm dart run build_runner build --delete-conflicting-outputs

gen_locale: # Generates localization and freezed files in project
	@fvm flutter gen-l10n --arb-dir "assets/localization" --template-arb-file "app_en.arb" --output-localization-file "app_localizations.gen.dart" --output-dir "lib/assets" --no-synthetic-package

install: # Install any required packages
	@dart pub global activate fvm
	@fvm install
	@fvm use
	@fvm dart pub global activate icons_launcher
	@fvm dart pub global activate patrol_cli
	@fvm dart pub global activate flutterfire_cli

integration_test: # Runs Patrol Integration tests 
	@patrol test --target integration_test --flavor develop

test: # Runs Flutter tests 
	@fvm flutter test

generateAndroidProductionAppBundle: # Clean everything and build Android AppBundle
	@make clean
	@fvm flutter build appbundle -t lib/main_production.dart --flavor production --obfuscate --split-debug-info=build/app/outputs/symbols

generateIosStagingIpa: # Clean everything and build iOS IPA
	@make clean
	@fvm flutter build ipa -t lib/main_staging.dart --flavor staging --obfuscate --split-debug-info=build/app/outputs/symbols

generateIosProductionIpa: # Clean everything and build iOS IPA
	@make clean
	@fvm flutter build ipa -t lib/main_production.dart --flavor production --obfuscate --split-debug-info=build/app/outputs/symbols

generateWebProduction: # Clean everything and build Web
	@make clean
	@fvm flutter build web -t lib/main_production.dart --web-renderer canvaskit

# This requires to have firebase-tools installed globally on the system.
# npm install -g firebase-tools
#
# It also requires to be logged in to firebase with the correct account.
# firebase login
#
# To get the project ID, run the following command:
# firebase projects:list
# TODO: Update project name or remove in case there is no web or when web is not hosted on Firebase.
deployWeb:
	@firebase deploy --project XXX

runner_gen: # For github actions
	@flutter pub get
	@flutter gen-l10n --arb-dir "assets/localization" --template-arb-file "app_en.arb" --output-localization-file "app_localizations.gen.dart" --output-dir "lib/assets" --no-synthetic-package
	@dart run build_runner build --delete-conflicting-outputs