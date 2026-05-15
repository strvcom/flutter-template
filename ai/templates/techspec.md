# Technical Specification Template

## Executive Summary

[Provide a brief technical overview of the solution approach. Summarize main architectural decisions and implementation strategy in 1-2 paragraphs. Mention which layers are touched: UI (`*_page.dart` / `*_page_content.dart`), state (`*_state.dart` / `*_event.dart`), data (DTOs/entities/use cases), and any platform integrations.]

## System Architecture

### Component Overview

[Brief description of main components and their responsibilities:

- Feature module under `lib/features/<feature>/` — pages, content widgets, state notifier, events
- Shared widgets/extensions reused from `lib/common/`
- Data layer: DTOs in `lib/common/data/dto/`, domain entities in `lib/common/data/entity/`, use cases, repositories
- Riverpod providers / `@riverpod` notifiers and how state flows into the UI
- Navigation entry via `auto_route` (`@RoutePage`, route registration)]

## Implementation Design

### Main Interfaces

[Define main contracts (≤20 lines per example). Prefer Dart abstract classes for repositories/use cases and `@riverpod` for state. Examples:

```dart
// Repository contract — implementations live in lib/common/data/
abstract class ExampleRepository {
  Future<ExampleEntity> fetch(String id);
  Stream<List<ExampleEntity>> watchAll();
}
```

```dart
// Riverpod state notifier — generated via riverpod_annotation
@riverpod
class ExampleController extends _$ExampleController {
  @override
  Future<ExampleState> build() async => ref.read(exampleRepositoryProvider).load();

  Future<void> onEvent(ExampleEvent event) async { /* ... */ }
}
```

Run `make gen` after touching `@riverpod`, `@freezed`, `@RoutePage`, or other codegen annotations.]

### Data Models

[Define essential data structures using project conventions:

- **DTOs** (`lib/common/data/dto/`) — wire-format models using `@freezed` with generated `fromJson` factories, used by `dio`
- **Entities** (`lib/common/data/entity/`) — domain models; map from DTOs via factory or extension
- **State models** — feature-scoped `@freezed` classes alongside the feature
- **Events** — sealed/`@freezed` union types for user/system events feeding the state notifier
- Local persistence: `shared_preferences` keys/migrations if applicable]

## Integration Points

[Include only if the feature requires external integrations:

- HTTP endpoints consumed via `dio` (auth, headers, error mapping through interceptors)
- Firebase services — Auth, Analytics, Crashlytics, Remote Config, Messaging
- Native platform channels (iOS / Android / desktop / web) if any
- Permissions handled via `permission_handler` and surfaced through `app_settings`
- Error handling: how failures are surfaced into state and logged via `talker`]

## Development Sequencing

### Build Order

[Define implementation sequence:

1. Data layer — DTOs, entity mapping, repository, use cases (run `make gen`)
2. State layer — `@riverpod` notifier, state/event classes, unit tests
3. UI layer — `*_page.dart` (thin) + `*_page_content.dart` (heavy UI)
4. Navigation wiring — `@RoutePage`, route registration, deep link if needed
5. Localization strings, assets, and final QA on supported platforms]

### Technical Dependencies

[List any blocking dependencies:

- Backend endpoints / API contracts ready
- Firebase project configuration (if new services are introduced)
- Required package additions to `pubspec.yaml`
- Native config changes (Android `build.gradle`, iOS `Info.plist`, entitlements)]

## Technical Considerations

### Main Decisions

[Document important technical decisions:

- Approach choice and justification (e.g., Riverpod `Notifier` vs. `AsyncNotifier`, repository vs. direct use case)
- Trade-offs considered
- Rejected alternatives and why]

### Known Risks

[Identify technical risks:

- Potential challenges (codegen drift, platform-specific behavior, web/desktop parity)
- Mitigation approaches
- Areas needing spike or research]

### Standards Compliance

[Review the rules in `AGENTS.md`, `docs/PROJECT_OVERVIEW.md`, `docs/PROJECT_GUIDELINES.md`, and the relevant `.claude/skills/*/SKILL.md` files that apply to this techspec and list them below.

Validation before merging:

- `make gen` (after annotation changes)
- `fvm flutter analyze`
- `fvm flutter test`
- Platform smoke run where touched (`fvm flutter run -t lib/main_develop.dart`)]

### Relevant Files

[List relevant files here — pages, content widgets, state/event, DTOs, entities, repositories, providers, route definitions, generated files to regenerate.]
