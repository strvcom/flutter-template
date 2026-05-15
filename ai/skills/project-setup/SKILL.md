---
name: project-setup
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
6. If Firebase support changes, run the Firebase Workflow below.
7. If secrets or signing material are needed, use the `secrets-bootstrap` workflow.
8. Run the AI Workflow Tooling Check below so repo-local skills and scripts are usable.
9. Update the README First steps checklist to mark any completed setup items with `[x]`.
10. Run `make gen` after setup changes that affect routes, localization, generated assets, or annotations.
11. Validate with `fvm flutter analyze` and the relevant tests.

## AI Workflow Tooling Check
Use this when setting up a new clone, preparing AI workflows, or debugging skill scripts.

1. Install project tooling:
   - Run `make install` to activate FVM, install the pinned Flutter SDK, and install project CLIs.
   - Ensure `fvm` is available either on `PATH` or at `$HOME/.pub-cache/bin/fvm`. Repo scripts fall back to that path when possible.
2. Install and authenticate GitHub CLI when PR workflows are needed:
   - Install `gh` with the platform package manager, for example `brew install gh` on macOS.
   - Run `gh auth login --hostname github.com --git-protocol ssh --web`.
   - Run `gh auth status` and fix any invalid `GITHUB_TOKEN` / `GH_TOKEN` environment variables if they override the stored login.
3. Verify repo-local script permissions and syntax:
   - `test -x ai/skills/build-verify/scripts/verify.sh`
   - `test -x ai/skills/lint_format/scripts/lint_format.sh`
   - `test -x ai/skills/release-builds/scripts/archive_ios_ipa.sh`
   - `bash -n ai/skills/build-verify/scripts/verify.sh`
   - `bash -n ai/skills/lint_format/scripts/lint_format.sh`
   - `sh -n ai/skills/release-builds/scripts/archive_ios_ipa.sh`
4. Verify Claude discovery wiring when Claude Code support is needed:
   - every `ai/skills/<name>/SKILL.md` has a matching `.claude/skills/<name>` symlink, except folder/name aliases such as `lint_format` -> `lint-format`
   - every skill has a matching `.claude/commands/<name>.md`
   - each symlink resolves to a `SKILL.md`
5. Run lightweight help checks:
   - `ai/skills/build-verify/scripts/verify.sh --help`
   - `ai/skills/lint_format/scripts/lint_format.sh --help`
   - `ai/skills/release-builds/scripts/archive_ios_ipa.sh` should print usage and exit non-zero when no flavor is supplied.

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

## Firebase Workflow
Use this workflow to automate step 9 from the README First steps checklist.

1. Determine whether Firebase should be kept or removed. If the request is unclear, ask because Firebase affects authentication, analytics, crash reporting, push notifications, remote config, web hosting, release distribution, and secrets.
2. If Firebase is kept:
   - Confirm the final supported platforms first, then configure only those platforms.
   - Ensure Firebase CLI and FlutterFire CLI are available through `make install` or `fvm dart pub global activate flutterfire_cli`.
   - Prefer `fvm flutterfire configure` when the Firebase project exists and the user can authenticate locally.
   - For manual setup, place Android `google-services.json` in `android/app/google-services.json` when Android is supported.
   - For iOS flavors, place `GoogleService-Info.plist` files under `ios/config/{develop,staging,production}/` when iOS is supported.
   - For web, replace placeholder web Firebase values in `lib/app/setup/setup_app.dart`, `web/firebase-messaging-sw.js`, and related `.env*` entries or document them as intentionally pending.
   - Inspect native integration after setup: Android Gradle Google Services, Crashlytics, App Distribution config, iOS plist copy script, iOS Crashlytics symbol upload script, and web Firebase hosting files.
   - Keep notification, Remote Config, and local notification startup disabled or enabled intentionally in `lib/app/setup/setup_app.dart`; do not assume scaffolded services are production-ready.
3. If Firebase is removed completely:
   - Remove Firebase packages from `pubspec.yaml`: `firebase_analytics`, `firebase_auth`, `firebase_core`, `firebase_crashlytics`, `firebase_messaging`, and `firebase_remote_config`.
   - Remove Firebase setup and imports from `lib/app/setup/setup_app.dart`.
   - Remove or replace Firebase-backed auth use cases under `lib/common/usecase/authentication/`.
   - Remove or replace Firebase-specific providers such as `firebase_messaging_service.dart`, `firebase_remote_config_service.dart`, and notification code that depends on `FirebaseMessaging`.
   - Remove or replace analytics and crash reporting wrappers that import Firebase, such as `lib/core/analytics/analytics_manager.dart` and `lib/core/analytics/crashlytics_manager.dart`.
   - Update landing, force-update, routing observer, logging, and social-login code paths that rely on Firebase apps, Firebase Auth, Remote Config, Analytics, Crashlytics, or Messaging.
   - Remove native Firebase integration from Android Gradle files, iOS/macOS generated plugin references if they are checked in, web Firebase service workers, Firebase hosting files when hosting is not used, and Firebase App Distribution workflows or docs if they no longer apply.
   - Run `fvm flutter pub get` after dependency removal.
4. Search for stale references with `rg`:
   - `firebase`, `Firebase`, `GoogleService`, `google-services`, `flutterfire`, `Crashlytics`, `RemoteConfig`, `FirebaseMessaging`, `FirebaseAuth`, `.firebaserc`, and `firebase.json`.
   - Treat encrypted secret files under `extras/secrets/` as secrets-owned unless the user explicitly asked to rotate or remove encrypted Firebase secrets.
5. Validate with `make gen` when generated providers or routes changed, then run `fvm flutter analyze` and relevant tests.
6. Mark README First steps item 9 as `[x]` only after Firebase has been configured for the intended platforms or removed completely.

## Dependency Checks
- Run `fvm dart pub outdated` inside `project_setup/` when touching the setup tool.
- Run `fvm flutter pub outdated` at the repo root when reviewing app dependencies.
- Keep setup-tool linting aligned with the root app when possible, especially `netglade_analysis`.

## Completion Criteria
- App name and package name are updated in native and Flutter files.
- Icon and splash generation completed without ignored subprocess failures.
- Platform decisions are reflected in native folders, `AppPlatform`, runtime setup, dependencies, and stale-reference searches.
- Firebase decisions are reflected in setup code, dependencies, platform config, native integration, generated files, docs, and stale-reference searches.
- Secrets decisions are reflected in files or documented as intentionally pending.
- Completed README First steps items are checked off with `[x]`.
- `make gen` completed when required.
- Analyze and relevant tests completed, or any blockers are clearly reported.
