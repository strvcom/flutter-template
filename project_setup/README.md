# Project Setup Tool
This Dart program is designed to streamline the initial setup process for a new Flutter project. It provides convenient tools to automate tasks such as generating app icons and splash screens based on predefined configurations. The configurations are specified in `/project_setup/lib/configuration.dart`.

- [App Icon Generation](#app-icon-generation)
- [Splash Screen Generation](#splash-screen-generation)


## App Icon Generation

### Step 1
Get your app icon from a designer and save it as `/project_setup/resources/icon.png`. This icon must be 900x900 with a transparent background.

### Step 2
All you need to do now is set the correct configuration in `/project_setup/lib/configuration.dart`.

### Step 3
Run `make install && make setup` in the project root, then select the option to generate new icons.


## Splash Screen Generation

### Step 1
Get your splash icon from a designer and save it as `/project_setup/resources/splash.png`. This icon should be 768x768 with a transparent background, and it MUST fit a circular shape.

### Step 2
All you need to do now is set the correct configuration in `/project_setup/lib/configuration.dart`.

### Step 3
Run `make setup` in the project root, then select the option to generate a new splash screen.

## Application Rebranding

### Step 1
All you need to do is set the correct application name and package name configuration in `/project_setup/lib/configuration.dart`.

### Step 2
Run `make setup` in the project root, then select the rename option.

## Validation Notes

- `make setup` runs `dart pub get` for this package before opening the menu.
- The icon and splash generators fail early when the input PNG has the wrong dimensions.
- External generation commands are checked; setup stops if `icons_launcher` or `flutter_native_splash` fails.
