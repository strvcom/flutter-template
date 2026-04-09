---
name: flutter-template-feature-data-flow
description: Build a full feature in this Flutter repository that includes backend or storage data flow: read API schema, create DTOs, map DTOs to entities, add Riverpod use cases, connect feature state, and render UI data. Use when a task goes beyond a screen and needs real data integration.
---

# Flutter Template Feature Data Flow

Use this skill when implementing a complete feature with data flow, not just a route or UI shell.

## Use This For
- a screen backed by API data
- a feature that needs request or response models
- a feature that needs DTO to entity mapping
- a feature that should load data into Riverpod state
- a feature that should read Swagger or backend schema before implementation

If the task is only a route and UI shell, prefer `flutter-template-feature-screen`.

## Read First
- `AGENTS.md`
- `docs/PROJECT_OVERVIEW.md`
- `docs/PROJECT_GUIDELINES.md`
- `build.yaml`
- `lib/core/network/dio_provider.dart`
- `lib/common/usecase/`
- `lib/common/data/dto/`
- `lib/common/data/entity/`

Useful current examples:
- `lib/common/data/dto/user_response_dto.dart`
- `lib/common/data/entity/user_entity.dart`
- `lib/common/usecase/user/get_current_user_use_case.dart`
- `lib/features/profile/profile_state.dart`

Backend reference when relevant:
- consult the adopting project's API docs or OpenAPI/Swagger spec
- check the configured API base URL in `Configuration.instance.apiHostUrl`
- check the environment value behind `API_HOST_URL` when verifying which backend you are integrating with

## Target Architecture
Aim for this flow:

```text
Feature UI
  -> feature state notifier
  -> use case
  -> dioProvider or shared storage layer
  -> DTO
  -> Entity
  -> feature state
  -> UI
```

## Workflow
1. Identify the user-facing behavior and the data needed by the screen or flow.
2. Read the backend contract first when the task depends on network payload shape.
3. Add request or response DTOs in `lib/common/data/dto/`.
4. Use `freezed` plus JSON serialization for DTOs that come from or go to the backend.
5. Name DTO files with the `*_dto.dart` pattern so `build.yaml` codegen picks them up.
6. Add app-facing entity models in `lib/common/data/entity/` when the UI should not consume the transport model directly.
7. Add conversion logic close to the DTO using an extension such as `SomeResponseDTOExtension`.
8. Add a focused Riverpod use case in `lib/common/usecase/` to perform the IO.
9. Keep the use case narrow: fetch, parse, map, and return the result.
10. Update the feature `*_state.dart` notifier to call the use case and store UI-ready values.
11. Emit one-off events through `*_event.dart` only for navigation, snackbars, dialogs, or similar side effects.
12. Render the result in `*_page_content.dart`, using `mapState` or `mapContentState` where appropriate.
13. Run `make gen`, then analyze and tests.

## DTO Guidance
- Put backend transport models in `lib/common/data/dto/`.
- Use `@freezed` and generated `fromJson` when the DTO is serialized.
- Keep DTO fields aligned with backend payload names and types.
- When backend enums are involved, prefer resilient parsing patterns such as explicit unknown cases where needed.

## Entity Guidance
- Put UI-facing or domain-facing models in `lib/common/data/entity/`.
- Entities may differ from DTOs if the UI needs a cleaner or safer shape.
- Prefer exposing entities to the rest of the app instead of leaking DTOs into widgets.

## Mapping Guidance
- Put mapping in an extension on the DTO when the conversion is straightforward.
- Example pattern:

```dart
extension ExampleResponseDTOExtension on ExampleResponseDTO {
  ExampleEntity toEntity() => ExampleEntity(...);
}
```

- Keep mapping explicit. Avoid hiding payload transformations in widgets.

## Use Case Guidance
- Use `@riverpod` use cases in `lib/common/usecase/`.
- Read `dioProvider` or the storage wrapper there, not in UI widgets.
- Return mapped entities or final values the feature state can consume directly.
- Catch and surface exceptions consistently with existing patterns where needed.

## Feature State Guidance
- The notifier in `*_state.dart` should orchestrate the feature.
- It should call use cases, update `AsyncValue`, and expose UI-ready data.
- It should not manually parse raw backend maps.

## Checklist
- DTO file added with `*_dto.dart` naming when needed
- entity file added when UI should not use the DTO directly
- DTO-to-entity mapping added through an extension
- use case added under `lib/common/usecase/`
- feature state calls the use case
- UI reads feature state instead of networking directly
- `make gen` completed
- analyze completed
- tests updated when behavior changed

## Watch Outs
- Do not put DTOs inside feature folders in this repo unless there is a strong existing precedent.
- Do not parse backend maps directly in state notifiers or widgets.
- Do not skip entity mapping just because DTO and UI shape look similar today.
- Check `build.yaml` if codegen does not fire; filename patterns matter here.
