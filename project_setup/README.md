# Project Setup Tool
This Dart program is designed to streamline the initial setup process for a new Flutter project. It provides many convenient tools to automate things, such as the generation of app icons and splash screens based on predefined configurations. The configurations are specified in a file located at `/project_setup/lib/configuration.dart`.

- [App Icon Generation](#app-icon-generation)
- [Splash Screen Generation](#splash-screen-generation)


## App Icon Generation

### Step 1
Get you app icon from designer and save it as `/project_setup/resources/icon.png`. This icon should be 750x750 with transparent background.

### Step 2
All you need to do now is to set correct configuration in `/project_setup/lib/configuration.dart`.

### Step 3
run `make install && make setup` in root folder of the project, and select generation of new icons.


## Splash Screen Generation

### Step 1
Get you splash icon from designer and save it as `/project_setup/resources/splash.png`. This icon should be 768x768 with transparent background, and MUST fit circular shape!

### Step 2
All you need to do now is to set correct configuration in `/project_setup/lib/configuration.dart`.

### Step 3
run `make setup` in root folder of the project, and select generation of new splash screen.

## Aplication Rebranding

### Step 1
All you need to do is to set correct application name and package name configuration in `/project_setup/lib/configuration.dart`.

### Step 2
run `make setup` in root folder of the project, and select rename option.