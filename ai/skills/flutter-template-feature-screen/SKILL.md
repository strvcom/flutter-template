---
name: flutter-template-feature-screen
description: Create a new Flutter screen in this repository using the existing feature structure, AutoRoute setup, Riverpod state pattern, and code generation workflow. Use when adding a new page, route, stateful screen, or feature folder in this template.
---

# Flutter Template Feature Screen

Use this skill when adding a new screen or route to this repository.

## Read First
- `AGENTS.md`
- `docs/PROJECT_OVERVIEW.md`
- `docs/PROJECT_GUIDELINES.md`
- `lib/app/navigation/app_router.dart`

## Default Output
Create work inside `lib/features/<feature>/`.

Prefer this shape when the screen owns state:

```text
lib/features/<feature>/
  <feature>_page.dart
  <feature>_page_content.dart
  <feature>_state.dart
  <feature>_event.dart
```

For simple static screens, `*_state.dart` and `*_event.dart` may be unnecessary.

## Workflow
1. Inspect nearby features with a similar level of complexity.
2. Create the new feature folder under `lib/features/`.
3. Add the route widget with `@RoutePage()`.
4. Put larger widget trees into `*_page_content.dart`.
5. If the screen has async state, create a `freezed` state plus `@riverpod` notifier in `*_state.dart`.
6. If the screen needs one-off navigation, snackbar, or dialog effects, create a `freezed` event union in `*_event.dart` and listen in the page widget.
7. Register the route in `lib/app/navigation/app_router.dart`.
8. Use shared widgets and extensions before adding new abstractions.
9. If data is needed, add DTOs, entities, and use cases in the shared locations instead of doing IO in widgets.
10. Run `make gen`, then `fvm flutter analyze`, then relevant tests.

## Conventions To Keep
- Keep `*_page.dart` thin.
- Prefer `CustomAppBar`, shared components, and shared compositions.
- Use `context.colorScheme`, `context.textTheme`, and `context.locale`.
- Use DTOs in `lib/common/data/dto/` and entities in `lib/common/data/entity/`.
- Put IO-oriented behavior in `lib/common/usecase/`.
- Use `AsyncValueExtension.mapState` or `mapContentState` for async UI.
- Do not hand-edit generated files.

## Checklist
- Route added and generated route class available
- Feature files follow the existing naming pattern
- No direct service wiring inside widgets unless the existing code already does it
- `make gen` completed
- Analyze completed
- Tests updated when behavior changed

## Watch Outs
- This template mixes fully-wired code with scaffolded placeholders. Check `lib/app/setup/setup_app.dart` before assuming a service is active.
- Do not invent a `CustomScaffold`; current template screens use `Scaffold` directly.
- Localization currently starts from `assets/localization/app_en.arb`. Add keys there and regenerate.
