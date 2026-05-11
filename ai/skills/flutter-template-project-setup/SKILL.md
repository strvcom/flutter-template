---
name: flutter-template-project-setup
description: Customize a new project created from this Flutter template, including app identity, package name, platform cleanup, icons, splash screen, Firebase/secrets decisions, setup tool execution, code generation, and validation.
---

# Flutter Template Project Setup

Use this skill when preparing a new app from this template or reviewing whether setup is complete.

## Read First
- `AGENTS.md`
- `README.md`
- `project_setup/README.md`
- `project_setup/lib/configuration.dart`
- `makefile`
- `docs/PROJECT_OVERVIEW.md`
- `docs/PROJECT_GUIDELINES.md`

## Safety Rules
- Keep deterministic mutations in the Dart setup tool under `project_setup/`.
- Do not touch decrypted `.env*`, signing files, or `extras/secrets/` unless the task explicitly includes secrets or signing setup.
- Do not hand-edit generated files such as `*.g.dart`, `*.freezed.dart`, `*.gr.dart`, or `lib/assets/*`.
- Treat Firebase, notifications, Remote Config, and web configuration as scaffolded until verified in `lib/app/setup/setup_app.dart`.

## Setup Workflow
1. Inspect the requested app name, package name, supported platforms, flavors, Firebase plan, and secret/signing needs.
2. Update `project_setup/lib/configuration.dart` for:
   - icon variants and colors
   - splash background colors and platforms
   - old/new app name
   - old/new package name
3. Verify setup image inputs:
   - `project_setup/resources/icon.png` must be `900x900`
   - `project_setup/resources/splash.png` must be `768x768`
4. Run `make setup` from the repository root and select the needed setup operation.
5. If platform support changes, run the Platform Cleanup Workflow below.
6. If Firebase is needed, follow the README Firebase section and inspect generated platform files before committing.
7. If secrets or signing material are needed, use the `flutter-template-secrets-bootstrap` workflow.
8. Run `make gen` after setup changes that affect routes, localization, generated assets, or annotations.
9. Validate with `fvm flutter analyze` and the relevant tests.

## Platform Cleanup Workflow
Use this workflow to automate step 4 from the README First steps checklist.

1. Determine the final supported platforms from the user request. Supported platform names are Android, iOS, web, Windows, Linux, snap, and macOS. If the request does not clearly say which platforms to keep or remove, ask before deleting platform folders.
2. Remove unsupported platform folders and files:
   - Android: `android/`
   - iOS: `ios/`
   - Web: `web/`, `firebase.json`, `.firebaserc`
   - Windows: `windows/`
   - Linux: `linux/`
   - Snap: `snap/`
   - macOS: `macos/`
3. Update `lib/app/setup/app_platform.dart`:
   - Remove enum values for deleted platforms.
   - Simplify derived getters such as `isMobile`, `isDesktop`, `isApple`, `isWeb`, and platform-specific getters so they only reference remaining enum values.
4. Update `lib/app/configuration/configuration.dart` so runtime platform detection only assigns remaining `AppPlatform` values. Replace deleted-platform branches with either a remaining fallback or an `UnsupportedError`, depending on the app's intended platform policy.
5. Update platform-specific setup code in `lib/app/setup/setup_app.dart`:
   - If web is removed, remove `package:flutter_web_plugins/url_strategy.dart`, `lib/app/setup/web_setup.dart`, `WebSetup.setup(...)`, and `usePathUrlStrategy()`.
   - If all desktop platforms are removed, remove `package:window_manager/window_manager.dart` and desktop window setup.
   - If specific desktop platforms are removed but at least one desktop remains, keep desktop setup only when it still applies.
6. Clean dependencies in `pubspec.yaml`:
   - If web is removed, remove `flutter_web_plugins` and `universal_html`.
   - If all desktop platforms are removed, remove `window_manager`.
   - After editing dependencies, run `fvm flutter pub get`.
7. Search for stale references with `rg`:
   - Removed platform enum values and getters, such as `AppPlatform.isWeb`, `AppPlatform.isLinux`, or `AppPlatform.macos`.
   - Removed imports, such as `web_setup.dart`, `flutter_web_plugins`, `universal_html`, and `window_manager`.
   - Removed native folders or generated files mentioned from build scripts, README snippets, or setup config.
8. Adjust or remove any code paths that only make sense for deleted platforms. Examples include native store open handling, force-update platform branches, Firebase messaging/web tokens, system bar setup, and launch/build documentation.
9. Run `fvm flutter analyze`. Run relevant tests when platform cleanup touches shared runtime logic.

## Dependency Checks
- Run `fvm dart pub outdated` inside `project_setup/` when touching the setup tool.
- Run `fvm flutter pub outdated` at the repo root when reviewing app dependencies.
- Keep setup-tool linting aligned with the root app when possible, especially `netglade_analysis`.

## Completion Criteria
- App name and package name are updated in native and Flutter files.
- Icon and splash generation completed without ignored subprocess failures.
- Platform decisions are reflected in native folders, `AppPlatform`, runtime setup, dependencies, and stale-reference searches.
- Firebase/secrets decisions are reflected in files or documented as intentionally pending.
- `make gen` completed when required.
- Analyze and relevant tests completed, or any blockers are clearly reported.
