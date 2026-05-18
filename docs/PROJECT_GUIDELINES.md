# Flutter Template Project Guidelines

These guidelines are intended to be safe defaults for contributors and AI assistants. They only document conventions that are visible in the current repository.

## Project Structure
- `lib/app`: app bootstrap, configuration, navigation, setup, and theme.
- `lib/common`: shared UI, data models, providers, use cases, extensions, and validation helpers.
- `lib/core`: wrappers around external services such as analytics, database, network, and Riverpod helpers.
- `lib/features`: feature folders, usually one folder per screen or flow.
- `lib/assets`: generated localization and asset accessors.

## Feature Layout
When a feature owns state, it commonly uses this file pattern:

```text
lib/features/<feature>/
  <feature>_page.dart
  <feature>_page_content.dart
  <feature>_state.dart
  <feature>_event.dart
```

Not every feature needs every file. Simple screens in the template only use `*_page.dart` and `*_page_content.dart`.

## Pages And UI
- Route widgets use `@RoutePage()`.
- Keep `*_page.dart` focused on route-level setup, event listeners, and scaffold structure.
- Put heavier widget trees in `*_page_content.dart`.
- Prefer shared widgets from `lib/common/component/` and `lib/common/composition/` before creating new primitives.
- Use `context.colorScheme`, `context.textTheme`, and `context.locale` from `lib/common/extension/build_context.dart` instead of duplicating theme or localization access.
- `CustomAppBar` is a common default for top bars.
- `Scaffold` is used directly in the current template. Do not assume a `CustomScaffold` exists.
- Edge-to-edge behavior is coordinated through `CustomSystemBarsTheme` in `lib/app/theme/custom_system_bars_theme.dart`.

## Shared UI: Components vs Compositions
- Use `lib/common/component/` for smaller reusable building blocks such as buttons, app bars, inputs, tabs, avatars, and low-level display widgets.
- Use `lib/common/composition/` for larger assembled UI blocks such as dialogs, placeholders, scroll containers, or responsive wrappers.
- Prefer extending an existing shared widget before creating a new feature-local abstraction with overlapping behavior.
- Keep shared UI widgets presentation-focused. Push IO, navigation, and state mutations back into feature notifiers, event listeners, or use cases.

## State Management
- Riverpod is the default state-management approach.
- Feature state is typically modeled with `freezed` classes ending in `State`.
- Stateful feature providers commonly use `@riverpod` classes ending in `StateNotifier`.
- Shared notifier helpers live in `lib/core/riverpod/state_handler.dart`.
- `AsyncValueExtension.mapState` and `mapContentState` from `lib/common/extension/async_value.dart` are the standard loading, error, and empty-state helpers.
- Keep `@Riverpod(keepAlive: true)` for app-scoped state or long-lived services, not one-shot command providers.
- For async use-case providers, prefer reading dependencies before the first `await` and continuing with captured objects instead of calling `ref` again later.
- If an auto-dispose use-case truly must access `ref` after an async gap, keep it alive only for that operation with `final link = ref.keepAlive(); try { ... } finally { link.close(); }`.
- If a page-scoped notifier resumes after `await`, guard UI-only follow-up work with `ref.mounted` before reading other providers or updating local state.

## One-Off Events
- One-off UI events use `EventNotifier<T>` from `lib/core/riverpod/event_notifier.dart`.
- Event payloads are often modeled as `freezed` unions in `*_event.dart`.
- Listen to event providers in the page widget and keep side effects such as navigation and snackbars there.

## Navigation
- AutoRoute is configured in `lib/app/navigation/app_router.dart`.
- Use generated route classes through `context.router`.
- The main authenticated shell is `RootRoute`, which hosts tab routes for Home, Events, and Profile.
- Other top-level routes currently include Landing, Authentication, Event Detail, and Debug Tools.

## Data And Networking
- Network access goes through `dioProvider` in `lib/core/network/dio_provider.dart`.
- Auth token injection is handled by `DioAuthorizationTokenInterceptor`.
- To skip auth for a request, set `options.extra[DioAuthorizationTokenInterceptor.requiresAuthDioExtraKey] = false`.
- Keep request and response payloads in `lib/common/data/dto/`.
- Keep app-facing models in `lib/common/data/entity/`.
- Map DTOs to entities close to the data layer instead of leaking transport models into widgets.
- Keep IO-oriented logic in Riverpod use cases under `lib/common/usecase/`.
- Use `Flogger` when extra diagnostics are useful in service or integration code.

## Notifications
- The repo currently uses Firebase Messaging and `flutter_local_notifications`, not OneSignal.
- Notification payload parsing lives in `lib/common/data/entity/notification_payload_entity.dart`.
- Notification display and open handling live in `lib/common/provider/notifications_service.dart`.
- Firebase messaging setup code exists in `lib/common/provider/firebase_messaging_service.dart`.
- Parts of notification startup are still commented out in `lib/app/setup/setup_app.dart`, so do not assume push notifications are fully enabled in every environment.

## Local Storage
- SharedPreferences access is centralized in `lib/core/database/shared_preferences.dart`.
- User persistence flows through `getDatabaseUserUseCase` and `setDatabaseUserUseCase`.
- `CurrentUserState` is the app-level cached user provider.

## Localization And Assets
- Localization is generated into `lib/assets/`.
- Add strings to the ARB files under `assets/localization/`.
- The current template only includes `assets/localization/app_en.arb`.
- Use generated localization through `context.locale`.
- Use generated asset accessors from `Assets.*` instead of raw asset paths whenever possible.
- Run `make gen` after changing localization inputs or asset declarations.

## Code Generation
- The repo uses `freezed`, `json_serializable`, `riverpod_generator`, `auto_route_generator`, and FlutterGen.
- Generation rules are defined in `build.yaml`.
- DTO codegen currently expects `*_dto.dart` naming in `lib/common/data/dto/`.
- Generated files are tool-owned and should not be edited manually.
- After changing annotations, routes, DTOs, localization, or assets, run `make gen`.

## FVM And Commands
- Flutter is managed with FVM. The pinned version lives in `.fvmrc`.
- Prefer `fvm flutter ...` and `fvm dart ...` commands over machine-global Flutter commands.
- If a non-interactive shell cannot find `fvm`, check `$HOME/.pub-cache/bin/fvm`; repo-local skill scripts use that fallback when available.
- Common commands:
  - `make gen`
  - `make watch`
  - `fvm flutter analyze`
  - `fvm flutter test`

## AI Workflow Tooling
- Repo-local skills live under `ai/skills/` and Claude Code symlinks live under `.claude/skills/`.
- Skill scripts should be executable and syntax-check clean before relying on them:
  - `bash -n ai/skills/build-verify/scripts/verify.sh`
  - `bash -n ai/skills/lint-format/scripts/lint-format.sh`
  - `sh -n ai/skills/release-builds/scripts/archive_ios_ipa.sh`
- PR-related skills use GitHub CLI. Install it locally and authenticate with `gh auth login`; verify with `gh auth status`.
- If `gh auth status` reports an invalid `GITHUB_TOKEN` or `GH_TOKEN`, clear or replace that environment variable so the stored GitHub CLI login can be used.

## Flutter And Package Upgrades
- Treat `.fvmrc` and `pubspec.yaml` as the source of truth for SDK and package versions.
- When upgrading Flutter, align the Flutter version in `pubspec.yaml` with `.fvmrc`.
- After SDK or dependency upgrades, run `fvm flutter pub get`, `make gen`, `fvm flutter analyze`, and `fvm flutter test`.
- Re-check generator compatibility when touching versioned pairs such as:
  - `freezed` and `freezed_annotation`
  - `json_serializable` and `json_annotation`
  - `riverpod_generator` and `riverpod_annotation`
  - `auto_route_generator` and `auto_route`
- For larger upgrades, inspect native platform files and startup integrations, especially Firebase, iOS pods, Android Gradle config, and generated code.

## Testing
- Widget tests live under `test/`.
- Patrol-based integration tests live under `integration_test/`.
- Patrol CLI is configured through `pubspec.yaml` with `patrol.test_directory: integration_test`.
- `make integration_test` runs `patrol test --flavor develop`.
- For Android integration tests, ensure `adb` is already available on your shell `PATH`.
- Add or update tests when the task calls for behavior changes, bug fixes, or new features. Do not assume tests are off-limits.

## Release And Versioning Notes
- The repo contains release-oriented files and commands such as `release_notes.txt`, Android app bundle generation, and iOS IPA generation.
- Keep release notes and version bumps consistent with the actual release task rather than changing them opportunistically during unrelated work.
- Treat branching, tagging, and publishing flow as team policy. The template README documents a default `develop` -> `staging` -> `master` flow, but an agent should confirm before applying release automation in a real project.
- For build-only release tasks, prefer existing make targets over inventing new commands.

## Adding A New Screen
1. Create a new folder under `lib/features/<feature>/`.
2. Add a `*_page.dart` route widget and a `*_page_content.dart` widget.
3. If the screen has async state or actions, add `*_state.dart` and optionally `*_event.dart`.
4. Register the route in `lib/app/navigation/app_router.dart`.
5. Use shared widgets, theme extensions, localization, and existing use-case patterns instead of wiring services directly in the UI.
6. Run `make gen` if the work changed routes, annotations, localization, DTOs, or assets.

## Template Caveats
- This repository includes template placeholders and TODOs, especially around Firebase setup, notifications, remote config, and web configuration.
- Read `lib/app/setup/setup_app.dart` before treating a service as production-ready.
- Prefer documenting newly discovered, stable conventions here instead of scattering AI instructions across multiple files.
