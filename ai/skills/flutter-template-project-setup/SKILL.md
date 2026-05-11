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
5. If platform support changes, remove platform-specific folders and dependencies consistently with the README first-steps checklist.
6. If Firebase is needed, follow the README Firebase section and inspect generated platform files before committing.
7. If secrets or signing material are needed, use the `flutter-template-secrets-bootstrap` workflow.
8. Run `make gen` after setup changes that affect routes, localization, generated assets, or annotations.
9. Validate with `fvm flutter analyze` and the relevant tests.

## Dependency Checks
- Run `fvm dart pub outdated` inside `project_setup/` when touching the setup tool.
- Run `fvm flutter pub outdated` at the repo root when reviewing app dependencies.
- Keep setup-tool linting aligned with the root app when possible, especially `netglade_analysis`.

## Completion Criteria
- App name and package name are updated in native and Flutter files.
- Icon and splash generation completed without ignored subprocess failures.
- Platform/Firebase/secrets decisions are reflected in files or documented as intentionally pending.
- `make gen` completed when required.
- Analyze and relevant tests completed, or any blockers are clearly reported.
