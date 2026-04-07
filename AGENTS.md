# AI Agent Guide

Use this file as the entrypoint for automated work in this repository.

## Read Order
1. `docs/PROJECT_OVERVIEW.md` for the repo map, startup flow, and feature inventory.
2. `docs/PROJECT_GUIDELINES.md` for implementation conventions and workflow defaults.
3. `README.md` for template setup, distribution, and platform-specific background.

## Repo Summary
- This is a Flutter template, not a fully productized app.
- Core stack: `flutter_riverpod`, `riverpod_annotation`, `freezed`, `json_serializable`, `auto_route`, `dio`, Firebase services, and FVM-managed Flutter.
- The app already includes example features, navigation, theming, codegen, localization, notifications, and release scaffolding.
- Some integrations are intentionally scaffolded but not fully enabled yet. Check `lib/app/setup/setup_app.dart` before assuming a service is active.

## Working Defaults
- Keep new screen work inside `lib/features/<feature>/`.
- Prefer the existing file pattern when a feature has state:
  - `*_page.dart`
  - `*_page_content.dart`
  - `*_state.dart`
  - `*_event.dart`
- Keep page widgets thin. Put heavier UI in `*_page_content.dart`.
- Prefer shared widgets and extensions from `lib/common/` before introducing new app-specific primitives.
- Keep network payload models in `lib/common/data/dto/` and map them into entities from `lib/common/data/entity/`.
- Use Riverpod providers and use cases instead of wiring IO directly in widgets.

## Codegen And Commands
- Run `make gen` after changing `@riverpod`, `@freezed`, `@RoutePage`, localization, or generated asset inputs.
- Use `make watch` for continuous code generation when doing annotation-heavy work.
- Do not hand-edit generated files such as `*.g.dart`, `*.freezed.dart`, `*.gr.dart`, or files under `lib/assets/`.
- Preferred validation commands:
  - `fvm flutter analyze`
  - `fvm flutter test`
  - `make gen`

## Safety Notes
- Secrets and environment-specific config exist in encrypted and generated forms. Avoid touching `extras/secrets/` or decrypted `.env*` files unless the task clearly requires it.
- Notifications, Remote Config, and some Firebase wiring are present in the codebase but parts of startup remain commented out in the template.
- Release and signing files exist in the repo. Treat versioning, tags, branch flow, and build scripts as developer-owned unless the task explicitly asks for release work.

## Documentation Rule
- If you learn a stable, repo-specific convention while working, update `docs/PROJECT_OVERVIEW.md` or `docs/PROJECT_GUIDELINES.md` instead of adding duplicate instructions elsewhere.

## Reusable Workflows
- Shared AI workflow guides live under `ai/skills/`.
- Use them for repeatable procedures such as:
  - creating a new feature screen
  - building a full data-backed feature
  - upgrading Flutter and dependencies
  - preparing a release branch and PR
  - running post-merge release builds
  - working with encrypted secrets and signing material
  - reviewing pull requests and diffs
