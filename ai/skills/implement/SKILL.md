---
name: implement
description: >
  Implement a single Flutter task following this repository's Riverpod, Freezed, AutoRoute,
  DTO/entity, codegen, and verification conventions. Reads the task definition, PRD, and
  tech spec, then executes the implementation. When invoked standalone, verifies the change;
  when invoked by implement-tasks-sequence, writes code only and leaves verification to
  start-job/build-verify.
  Use when the user says "implement task X", "work on task X", or wants to execute
  a specific task from the task list.
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, Agent
model: claude-sonnet-4-6
---

# Flutter Template Task Implementation

You are responsible for implementing one task from a Flutter feature plan while following the repository standards.

## Objectives
1. Read and understand the task definition
2. Review the PRD and tech spec for context
3. Apply relevant Flutter skills and repository conventions
4. Execute the implementation
5. Verify the change when running standalone, or explicitly skip verification when called by `implement-tasks-sequence`

## File Locations
- PRD: `.claude/tasks/[feature-name]/prd.md`
- Tech Spec: `.claude/tasks/[feature-name]/techspec.md`
- Task: `.claude/tasks/[feature-name]/[num]_task.md`
- Task list: `.claude/tasks/[feature-name]/tasks.md`

## Applicable Skills
- `feature-screen` — when the task adds or changes a screen, route, page split, UI state, or navigation.
- `feature-data-flow` — when the task adds backend/storage data flow, DTOs, entities, use cases, or state that loads real data.
- `lint-format` — when running standalone and the change does not need the broader `build-verify` suite.
- `build-verify` — when running standalone and the task changed behavior, generated-code inputs, routes, platform setup, dependencies, tests, or other shared behavior.
- `pr-review` — optional standalone final check when the user asks for a review after implementation.

Do not use KMP, Swift, iOS coordinator, Gradle, Spotless, Detekt, Tuist, or native iOS test-runner skills in this Flutter workflow.

## Invocation Modes

### Standalone mode
Use when the user directly asks to implement one task. Complete implementation and run the appropriate verification commands before reporting done.

### Sequence mode
Use when called by `implement-tasks-sequence`. In this mode:
- read the same task, PRD, and tech spec
- write only the source changes for the assigned task
- do not run builds, tests, `lint-format`, `build-verify`, or `pr-review`
- do not commit or stage
- report what changed and return control to the orchestrator

## Workflow

### Step 1: Pre-Task Setup

Read the task file, PRD, and tech spec. Understand:
- What this task should accomplish
- How it fits into the broader feature
- Dependencies on prior tasks (verify they are complete)
- Whether this task is part of a currently running sequence or standalone

### Step 2: Task Analysis

Identify:
- Which files under `lib/features/<feature>/`, `lib/common/`, `lib/core/`, `assets/localization/`, platform folders, or tests need to be created or modified
- Whether the task is UI-only, stateful, data-backed, navigation-related, platform/setup-related, or test-only
- Which generated-code inputs are affected: `@riverpod`, `@freezed`, `@RoutePage`, DTO JSON serialization, localization, or assets
- The testing and verification strategy for standalone mode

### Step 3: Implementation Plan

Before writing code, briefly outline the approach. For non-trivial standalone tasks, share the plan with the user if the user asked to review the approach first. When called by `implement-tasks-sequence`, keep the plan internal and proceed.

### Step 4: Execute Implementation

Write the code following `AGENTS.md`, `docs/PROJECT_OVERVIEW.md`, `docs/PROJECT_GUIDELINES.md`, and the relevant feature skills.

Use these default patterns:
- Put feature route widgets in `lib/features/<feature>/<feature>_page.dart`.
- Put larger widget trees in `lib/features/<feature>/<feature>_page_content.dart`.
- Use `*_state.dart` with `freezed` and `@riverpod` when the feature owns async or mutable state.
- Use `*_event.dart` with `EventNotifier` for one-off effects such as navigation, dialogs, or snackbars.
- Keep IO in `lib/common/usecase/`; do not wire network or storage directly in widgets.
- Keep transport models in `lib/common/data/dto/` and app-facing models in `lib/common/data/entity/`.
- Register routes in `lib/app/navigation/app_router.dart` when adding `@RoutePage()` widgets.
- Use shared widgets from `lib/common/component/` and `lib/common/composition/` before adding new primitives.
- Use `context.colorScheme`, `context.textTheme`, and `context.locale`.
- Add localization strings to `assets/localization/*.arb` and use generated localization accessors.
- Do not hand-edit generated files such as `*.g.dart`, `*.freezed.dart`, `*.gr.dart`, or `lib/assets/**`.
- Check `lib/app/setup/setup_app.dart` before assuming Firebase, notifications, or Remote Config startup behavior is active.

**Critical: no workarounds.** Implement root-cause solutions. If you hit a blocker, investigate the cause rather than suppressing warnings, bypassing architecture, editing generated output, or adding temporary shims.

### Step 5: Testing & Verification (Mandatory)

In standalone mode, verify before considering the task complete.

Use the smallest sufficient verification:
- Run `make gen` when annotations, routes, DTOs, localization, or asset inputs changed.
- Run `ai/skills/lint-format/scripts/lint-format.sh` for normal Dart/Flutter code changes.
- Run `fvm flutter test` when behavior, state, use cases, widgets, or tests changed.
- Run `ai/skills/build-verify/scripts/verify.sh` for broad, cross-platform, dependency, startup, routing, generated-code, or PR-ready tasks.
- Run `make integration_test` only when Patrol integration flows changed or the user asks for it.

If any step fails, fix the underlying issue and re-run the failed verification. Do not disable checks, delete tests, add broad `// ignore:` comments, or hand-edit generated files to make verification pass.

In sequence mode, skip this step and explicitly state that final verification is delegated to `build-verify`.

### Step 6: Mark Task Complete

Update the matching task checkbox in `.claude/tasks/[feature-name]/tasks.md` to `[x]` only after the task's source changes are complete.

If the task cannot be completed, leave the checkbox unchecked and report the blocker clearly.

## Rules

- Do not edit the PRD or tech spec unless the user explicitly asks for spec updates.
- Do not stage, commit, or push.
- Do not touch files outside the task scope unless the task cannot work without that change.
- Preserve unrelated user or agent changes in the worktree.
- Prefer existing repo patterns over new abstractions.
- Add or update tests when the task changes behavior, state, validation, data mapping, or user-facing flows.
- Report what was implemented, which files changed, verification run or intentionally skipped, and any decisions or blockers.
