<vision>
## What are we building?
[Clear description of what this feature/system does]

## Why are we building it?
[Business value, user problem being solved]

## How does it connect to everything else?
[Where does data flow from/to? Which existing features, providers, repositories, or services does this touch?]

## What does success look like?
[Concrete outcome - what should the user be able to do when this is done?]
</vision>

<foundation>
## Data Model

### Entities
[Define the core entities, their fields, and relationships.
- DTOs live in `lib/common/data/dto/` (annotated with `@freezed` + `@JsonSerializable`)
- Domain entities live in `lib/common/data/entity/` (mapped from DTOs)
- Feature-scoped state/event types live next to the feature as `*_state.dart` / `*_event.dart`]

### Seed Data
[Initial data needed — local fixtures, env defaults, remote config keys, etc.]

## Dependencies

### Requires (inputs)
- [APIs (`dio` endpoints), providers, repositories, or use cases this consumes]
- [Required Firebase services or platform permissions]

### Provides (outputs)
- [New providers, repositories, routes, or use cases this exposes to the rest of the app]

### Third-party integrations
- [External APIs, SDKs, Firebase modules, or platform channels needed]
</foundation>

<implementation>
## Core Behavior
[Describe the main flows and logic — user interactions, state transitions, side effects, error handling.]

## Key Screens/Components
[List the main pages/widgets, following the project convention:
- `*_page.dart` — thin route widget (`@RoutePage`)
- `*_page_content.dart` — heavier UI composition
- `*_state.dart` / `*_event.dart` — Riverpod state + events
Reuse from `lib/common/` (widgets, extensions) before introducing new primitives.]

## Edge Cases
[What happens when things go wrong? Empty states, loading, errors, no network, permission denied, auth expired, etc.]
</implementation>

<constraints>
## Must Have
- [Non-negotiable requirement]

## Must NOT Have
- [What to avoid — tech debt, anti-patterns (e.g., IO directly in widgets, hand-editing generated `*.g.dart` / `*.freezed.dart` / `*.gr.dart`)]

## Follow Existing Patterns From
- [Reference feature folder under `lib/features/<existing>/` whose page/content/state/event split should be mirrored]
- [Reference DTOs/entities/use cases under `lib/common/data/` to match]
</constraints>

<quality_gates>
## No Gaping Problems
- [ ] [Check that prevents future refactoring]
- [ ] `make gen` runs clean after annotation changes
- [ ] `fvm flutter analyze` passes with no new warnings
- [ ] `fvm flutter test` passes (add tests for new providers/use cases)

## Ready to Ship
- [ ] [What "good enough" looks like for v1]
- [ ] Smoke-tested on the supported platforms touched by this feature
</quality_gates>

<questions>
## Clarify Before Starting

> If any of the following are unclear or missing, **ASK before implementing**. Do not assume or invent solutions.

- [ ] Is the data model complete? Any missing fields or relationships in DTOs/entities?
- [ ] Are all dependencies available (API endpoints, Firebase config, packages in `pubspec.yaml`)?
- [ ] Which existing feature under `lib/features/` should this match in structure?
- [ ] What's the priority — speed to ship or polish?
</questions>

<context>
## Reference Materials
- [Link to relevant PRD, techspec, wireframes, or specs]
- `docs/PROJECT_OVERVIEW.md`, `docs/PROJECT_GUIDELINES.md`, `AGENTS.md`

## Codebase Location
- Feature path: `lib/features/<feature>/`
- Shared data: `lib/common/data/dto/`, `lib/common/data/entity/`
- Shared UI / extensions: `lib/common/`
- Routes / app wiring: `lib/app/`
- Related code: `[existing feature(s) to reference]`
</context>
