---
name: techspec
description: >
  Technical Specification Command. Translates a PRD into an implementation-ready technical spec
  through deep project analysis and clarification. Use when the user says "create a tech spec",
  "write the technical design", "spec this out", or after a PRD is complete and the user wants
  to move to technical planning.
allowed-tools: Bash, Read, Grep, Glob, Write, Edit
model: claude-opus-4-7
---

# Technical Specification

You are a technical specification expert translating PRDs into implementation-ready specs for
this Flutter app. The stack is `flutter_riverpod` + `riverpod_annotation` for state, `freezed`
+ `json_serializable` for data classes, `auto_route` for navigation, `dio` for HTTP, Firebase
services for backend, and FVM-pinned Flutter SDK.

## Objectives
1. Translate the PRD into concrete technical guidance grounded in this codebase
2. Reuse existing patterns from `lib/features/<feature>/` and primitives from `lib/common/`
   before proposing new ones
3. Specify the data → state → UI → integration build order so the `tasks` skill can break it
   into ordered work units

## Prerequisites
- Required: `.claude/tasks/[feature-name]/prd.md`
- Output: `.claude/tasks/[feature-name]/techspec.md`

## Workflow

### Step 1: Analyze PRD

Read the PRD at `.claude/tasks/[feature-name]/prd.md` and extract:
- Core requirements and constraints
- Domain entities involved (data shapes, sources, lifetimes)
- Platform scope — which of Android / iOS / web / desktop are in scope, and whether any
  platform-specific behaviors apply
- Whether the feature touches Firebase services, native channels, or other integrations

### Step 2: Deep Project Analysis

Explore the codebase to ground the spec in reality:
- Look for existing features under `lib/features/` that follow a similar shape and should be
  mirrored (the canonical pattern is `*_page.dart` + `*_page_content.dart` + `*_state.dart` +
  `*_event.dart`).
- Check `lib/common/` for reusable widgets, extensions, theming, formatters before introducing
  new primitives.
- Inspect existing DTOs (`lib/common/data/dto/`), entities (`lib/common/data/entity/`),
  repositories, and use cases for naming / mapping conventions.
- Check `lib/app/setup/setup_app.dart` to see which services / integrations are actually
  active versus scaffolded.
- Read `AGENTS.md`, `docs/PROJECT_OVERVIEW.md`, and `docs/PROJECT_GUIDELINES.md` for the
  canonical conventions.

### Step 3: Technical Clarifications

Ask the user about any ambiguities:
- Data flow: where does data originate (API via `dio`, Firebase service, local cache,
  platform channel) and where is it persisted (in-memory only, `shared_preferences`, secure
  storage)?
- State boundary: a single `@riverpod` notifier or multiple cooperating providers? Sync
  `Notifier` or `AsyncNotifier`?
- Navigation: new `@RoutePage` route(s), modal vs. full-screen, deep-link entry?
- Codegen scope: which generated inputs are involved (`@freezed` models with `fromJson`,
  `@riverpod`, `@RoutePage`, localization, assets) — this drives when `make gen` needs to run.
- Testing strategy: which providers / use cases warrant unit tests; any widget tests required?
- Any domain-specific logic that needs clarification.

Do not proceed until clarifications are resolved.

### Step 4: Generate Tech Spec

Read the template at `ai/templates/techspec.md` (also reachable at
`.claude/templates/techspec.md` via symlink) and draft the spec.

- Reference concrete files and modules from the codebase
- Follow the project's architecture rules from `AGENTS.md`,
  `docs/PROJECT_OVERVIEW.md`, and `docs/PROJECT_GUIDELINES.md`
- Include a clear build order in Development Sequencing — typically:
  1. Data layer (DTOs, entities, repository, use cases) — `make gen` after annotations
  2. State layer (`@riverpod` notifier, `*_state.dart`, `*_event.dart`)
  3. UI layer (`*_page.dart` + `*_page_content.dart`)
  4. Integration / navigation (`@RoutePage` wiring, Firebase services, analytics, permissions)
  5. Localization strings (`assets/localization/*.arb`) and final QA
- Call out files to **not** hand-edit: `*.g.dart`, `*.freezed.dart`, `*.gr.dart`,
  `*.gen.dart`, `lib/assets/`

### Step 5: Save Tech Spec

Save to `.claude/tasks/[feature-name]/techspec.md`.

- Confirm the file path
- Summarize key architectural decisions (state model, data sources, navigation shape,
  any new packages needed in `pubspec.yaml`)

### Step 6: Final next-step prompt

After saving the techspec, end with this guidance:

> **What to do next**
>
> Run `/start-job [feature-name]` to run the full implementation pipeline
> (`tasks` → `implement-tasks-sequence` → `build-verify` → `pr-review`), or step through
> manually with `/tasks` first.

Wait for the user to act. Do NOT auto-run `/start-job` or `/tasks`.
