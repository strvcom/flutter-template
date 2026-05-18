# Implementation Tasks for [Feature Name]

## Overview
[Brief description]

## Task List
### Phase 1: Foundation (data layer)
- [ ] 1.0 [Task title — DTOs, entities, repository, use cases; run `make gen` after annotation changes]

### Phase 2: Core Implementation (state + UI)
- [ ] 2.0 [Task title — `@riverpod` notifier, `*_state.dart`, `*_event.dart`, `*_page.dart`, `*_page_content.dart`]

### Phase 3: Integration (navigation, services, platform)
- [ ] 3.0 [Task title — `@RoutePage` wiring, Firebase / platform integrations, analytics events, permissions]

### Phase 4: Verification
- [ ] 4.0 `make gen` clean
- [ ] 4.1 `fvm flutter analyze` passes
- [ ] 4.2 `fvm flutter test` passes (with new tests for providers / use cases)
- [ ] 4.3 Smoke run on target platforms (`fvm flutter run -t lib/main_develop.dart`)

## Dependency Graph
```
1.0 → 2.0 → 3.0 → 4.0
```
