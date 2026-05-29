---
name: upgrade
description: Upgrade Flutter and package dependencies in this repository while keeping .fvmrc, pubspec.yaml, code generation, CI, and tests aligned. Use when bumping Flutter, Dart constraints, direct dependencies, or generator toolchains.
allowed-tools: Bash, Read, Grep, Glob, Edit, Write
model: claude-sonnet-4-6
---

# Flutter Template Upgrade

Use this skill for SDK and dependency upgrades in this repository.

## Read First
- `AGENTS.md`
- `docs/PROJECT_GUIDELINES.md`
- `.fvmrc`
- `pubspec.yaml`
- `makefile`
- `build.yaml`
- `.github/workflows/`

## Upgrade Goals
- Keep `.fvmrc` and `pubspec.yaml` aligned.
- Let `pub` resolve compatible versions rather than guessing.
- Regenerate all generated code after package changes.
- Fix API migrations and lint changes introduced by the newer toolchain.
- Verify local commands and CI still reflect the project pin.

## Workflow
1. Check current SDK pin in `.fvmrc` and `pubspec.yaml`.
2. Confirm the target Flutter version.
3. Update `.fvmrc`.
4. Activate the new SDK locally — this always needs to happen after changing `.fvmrc`:
   ```
   fvm install
   fvm use global <version>
   ```
   Without this, `fvm flutter` commands still invoke the old SDK.
5. Update `.vscode/settings.json` — change `dart.flutterSdkPath` to `.fvm/versions/<new-version>`.
   Then **restart VSCode** (or run "Dart: Change Flutter SDK" from the command palette) so the
   Dart/Flutter extension reloads against the new SDK. Skipping this causes the IDE to keep
   analyzing with the old version even though the CLI is already on the new one.
6. Update `pubspec.yaml` environment constraints to match the new SDK floor.
7. Run dependency audit commands such as `fvm flutter pub outdated`.
8. Use `fvm flutter pub upgrade --major-versions` when the goal is to move the dependency graph forward broadly.
9. Review any changed direct constraints in `pubspec.yaml`.
10. Run:
    - `fvm flutter pub get`
    - `make gen`
    - `fvm flutter analyze`
    - `fvm flutter test`
11. Fix breakages from:
    - package API changes
    - analyzer/lint changes
    - build runner or codegen config warnings
    - generated native plugin files
12. Review GitHub Actions to ensure they still use the pinned project SDK.

## Version Pairs To Check Together
- `freezed` with `freezed_annotation`
- `json_serializable` with `json_annotation`
- `riverpod_generator` with `riverpod_annotation`
- `auto_route_generator` with `auto_route`

## Common Migration Hotspots In This Repo
- `flutter gen-l10n` flags in `makefile`
- `build.yaml` builder names or deprecated sections
- `flutter_local_notifications` API changes
- stricter lints from upgraded analyzer and `netglade_analysis`
- generated files under `linux/flutter/` and `windows/flutter/`
- workflow Flutter pinning in `.github/workflows/`

## Completion Criteria
- `.fvmrc` and `pubspec.yaml` match
- `pubspec.lock` updated
- `make gen` succeeds
- analyze succeeds
- widget tests succeed
- any remaining unresolved latest versions are explained, not ignored silently
