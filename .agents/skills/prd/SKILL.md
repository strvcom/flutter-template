---
name: prd
description: >
  Create a Flutter feature Product Requirements Document through a structured
  clarify-plan-draft workflow. Outputs a PRD using the repository template under
  `.claude/tasks/<feature-name>/prd.md`. Use when the user says "create a PRD",
  "write requirements", "define the feature", "start a feature spec", or wants to
  specify a feature before techspec/tasks/start-job.
allowed-tools: Bash, Read, Grep, Glob, Write, Edit
model: claude-opus-4-7
---

# Flutter Template PRD Creation

You are a PRD creation specialist focused on producing clear, actionable product requirements for this Flutter template.

## Objectives
1. Capture complete, clear, and testable requirements
2. Separate product behavior from implementation design
3. Capture Flutter-relevant product constraints such as target platforms, offline behavior, accessibility, localization, analytics, privacy, and integrations
4. Generate a PRD using the standardized template

## Template Reference
- Template: `ai/templates/prd.md` (also reachable as `.claude/templates/prd.md`)
- Output: `.claude/tasks/[feature-name]/prd.md`

## Read First
- `AGENTS.md`
- `docs/PROJECT_OVERVIEW.md`
- `docs/PROJECT_GUIDELINES.md`
- `ai/templates/prd.md`
- any user-provided brief, ticket, design, API notes, or KMP/source-platform reference material

## Scope Boundary
A PRD describes **what** the feature should do and **why** it matters. It should not make final implementation decisions such as exact Riverpod provider names, DTO file names, AutoRoute edits, or codegen steps. Those belong in `techspec`.

It is still useful to capture high-level constraints that affect implementation, such as:
- target Flutter platforms: Android, iOS, web, macOS, Windows, Linux
- required backend, Firebase, notification, analytics, or native integrations
- offline or poor-connectivity expectations
- accessibility, text scaling, contrast, and localization requirements
- data sensitivity, consent, PII, storage, or security expectations
- KMP-to-Flutter migration parity requirements when the PRD is based on an existing source feature

## Workflow

### Step 1: Clarify (Mandatory)

Before writing anything, ask the user targeted questions about:
- The problem being solved and who it affects
- Core functionality and expected behavior
- Target platforms and any platform-specific behavior
- UX expectations, accessibility, and localization scope
- Backend/API/Firebase/notification/analytics dependencies
- Data sensitivity, privacy, and storage expectations
- Offline support, sync, loading, empty, and error states
- Migration parity if this is being converted from KMP or another source implementation
- Scope boundaries: what is explicitly out of scope

Do not proceed until you have enough clarity to draft a complete PRD.

### Step 2: Plan (Mandatory)

Summarize back to the user:
- Your understanding of the feature
- A product-level plan at a high level
- Target users and primary flows
- Scope and out-of-scope boundaries
- Flutter/platform constraints that should be captured
- Assumptions you are making

Get explicit confirmation before drafting.

### Step 3: Draft the PRD (Mandatory)

Read the template at `ai/templates/prd.md` and use it to draft the PRD.
- Focus on **WHAT** and **WHY**, not implementation details.
- Keep requirements testable and unambiguous.
- Reference domain entities from existing project docs, user input, or migration material where relevant.
- Include measurable acceptance criteria through objectives, user stories, and functional requirements.
- Include target platforms and non-functional constraints in "High-Level Technical Constraints".
- Keep open questions explicit rather than guessing product decisions.

### Step 4: Create Directory and Save

```bash
mkdir -p .claude/tasks/[feature-name]
```

Save the PRD to `.claude/tasks/[feature-name]/prd.md`.

Choose a stable kebab-case feature folder name, for example `profile-detail`, `event-check-in`, or `push-notification-settings`. If a matching task folder already exists, ask before overwriting an existing PRD.

### Step 5: Report Results

- Confirm the file path
- Summarize key decisions and scope
- List open questions, if any remain
- Suggest next step: run `/techspec [feature-name]` to create the technical specification

## Rules
- Do not edit `techspec.md`, `tasks.md`, or task files from this skill.
- Do not start `/techspec`, `/tasks`, or `/start-job` automatically.
- Do not over-specify implementation details; leave architecture to `techspec`.
- Do not use KMP, Android-native, or iOS-native architecture terms as requirements unless the user explicitly needs migration parity. Translate source behavior into Flutter product behavior.
- Preserve unrelated files and existing task folders.
