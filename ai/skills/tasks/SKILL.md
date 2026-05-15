---
name: tasks
description: >
  Task Breakdown Command. Breaks a feature into discrete, dependency-ordered implementation tasks
  from a PRD and tech spec. Creates a task list and individual task files with no approval prompt.
  When run inside the `/start-job` pipeline, return control to that orchestrator so it can invoke
  the implementation phase. When invoked standalone, stop after generating tasks and prompting
  for the next step.
  Use when the user says "break this down into tasks", "create tasks", "task breakdown",
  or after the tech spec is complete and the user wants to plan implementation.
allowed-tools: Bash, Read, Grep, Glob, Write, Edit
model: claude-sonnet-4-6
---

# Task Breakdown

You are specialized in breaking down features into discrete, manageable implementation tasks.

## Objectives
1. Break down the feature into independently completable tasks
2. Establish clear dependency ordering
3. Create task files that an agent can execute without ambiguity

## Prerequisites
- PRD: `.claude/tasks/[feature-name]/prd.md`
- Tech Spec: `.claude/tasks/[feature-name]/techspec.md`

## Workflow

### CRITICAL: Do NOT ask for approval.
The user does not want to review the task list before implementation. Generate the tasks, keep the
total count reasonable (aim for cohesive tasks, not micro-tasks), and stop after reporting.
The caller (`/start-job` or the user directly) decides what runs next.

### Step 1: Analyze PRD and Tech Spec

Read both documents and identify:
- All components that need to be built
- The dependency graph between components
- Which tasks can be parallelized

### Step 2: Generate Task Structure

Order tasks following this Flutter-stack progression (mirrors the `ai/templates/task-list.md`
phases):

1. **Foundation (data layer)** — DTOs in `lib/common/data/dto/` (`@freezed` with
   generated `fromJson` factories), domain entities in `lib/common/data/entity/`, repositories, and
   use cases. Run `make gen` after annotation changes.
2. **Core implementation (state + UI)** — `@riverpod` notifiers, `*_state.dart` /
   `*_event.dart` (feature-scoped freezed types), and the page split:
   `*_page.dart` (thin `@RoutePage` widget) + `*_page_content.dart` (heavier UI).
3. **Integration (navigation, services, platform)** — `@RoutePage` wiring in
   `lib/app/`, Firebase / platform integrations, analytics events, permissions, native
   channels.
4. **Tests and verification** — only when explicitly required by the PRD / techspec.
   Standard analyze / test / build verification is handled by `build-verify` at the end of
   the flow, so don't add a "run analyze" task unless the feature itself requires custom
   coverage.

Group tasks into phases. Each task should be:
- Small enough to complete in one focused session
- Large enough to be meaningful (not trivially small)
- Scoped so later tasks don't have to unwind earlier ones

Keep the total number of tasks reasonable — prefer fewer, well-scoped tasks over many tiny ones.

### Step 3: Create Task Summary

Use the template at `ai/templates/task-list.md` (also reachable as
`.claude/templates/task-list.md` via symlink) to generate:
`.claude/tasks/[feature-name]/tasks.md`

### Step 4: Generate Individual Task Files

Use the template at `ai/templates/task.md` (also reachable as `.claude/templates/task.md`
via symlink) to create:
`.claude/tasks/[feature-name]/[num]_task.md`

Each task file should include:
- Clear vision of what the task accomplishes
- Data model details — DTO / entity / state / event types and their location under
  `lib/common/data/` or `lib/features/<feature>/`
- Implementation steps — referencing the existing feature pattern
  (`*_page.dart` + `*_page_content.dart` + `*_state.dart` + `*_event.dart`)
- Constraints — no IO in widgets, no hand-edits to generated files (`*.g.dart`,
  `*.freezed.dart`, `*.gr.dart`), reuse from `lib/common/` before adding new primitives
- Quality gates — `make gen` clean, `fvm flutter analyze` passes, `fvm flutter test` passes

### Step 5: Brief Summary

Output a one-paragraph summary (what was generated, how many tasks, dependency shape). Keep it
tight. Do NOT invoke any follow-up skills.

### Step 6: Prompt Next-Step Choice

**If (and only if) this skill was invoked directly by the user** (not by `/start-job`), end by
asking how they want to proceed:

> **Next step — how do you want to continue?**
>
> - **`/start-job`** — run the remaining phases in one shot: implement-tasks-sequence →
>   build-verify → pr-review. Nothing will be committed.
> - **Manual** — step through each phase yourself (`/implement-tasks-sequence`, then
>   `/build-verify`, then `/pr-review`).

Wait for the user's choice. Do NOT auto-run anything.

When invoked by `/start-job`: skip the prompt above and return control to the `/start-job`
orchestrator. The orchestrator must then invoke `implement-tasks-sequence` as Phase 2 without
pausing for user input.

## Project context

This is a Flutter app using:
- `flutter_riverpod` + `riverpod_annotation` for state and DI
- `freezed` + `json_serializable` for data classes (DTOs, entities, states, events)
- `auto_route` for navigation (`@RoutePage`)
- `dio` for HTTP, Firebase services for backend
- FVM-pinned Flutter SDK (see `.fvmrc`)

Refer to `AGENTS.md`, `docs/PROJECT_OVERVIEW.md`, and `docs/PROJECT_GUIDELINES.md` for the
canonical conventions to bake into task descriptions. Prefer reusing primitives from
`lib/common/` before introducing new ones, and follow the existing feature folders under
`lib/features/<feature>/` as the structural reference.
