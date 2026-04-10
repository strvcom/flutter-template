---
name: flutter-template-upgrade
description: Upgrade Flutter and package dependencies in this repository while keeping .fvmrc, pubspec.yaml, code generation, CI, and tests aligned. Use when bumping Flutter, Dart constraints, direct dependencies, or generator toolchains.
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
4. Update `pubspec.yaml` environment constraints to match the new SDK floor.
5. Run dependency audit commands such as `fvm flutter pub outdated`.
6. Use `fvm flutter pub upgrade --major-versions` when the goal is to move the dependency graph forward broadly.
7. Review any changed direct constraints in `pubspec.yaml`.
8. Run:
   - `fvm flutter pub get`
   - `make gen`
   - `fvm flutter analyze`
   - `fvm flutter test`
9. Fix breakages from:
   - package API changes
   - analyzer/lint changes
   - build runner or codegen config warnings
   - generated native plugin files
10. Review GitHub Actions to ensure they still use the pinned project SDK.

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
