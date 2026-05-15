---
name: pr-review
description: Review pull requests and diffs in this Flutter repository with a bug-finding mindset. Use when asked to review changes, review a PR, audit a diff, or check for regressions, missing tests, release risks, or architecture mismatches.
---

# Flutter Template PR Review

Use this skill when reviewing a pull request, branch diff, or a set of code changes in this repository.

## Review Goal
Prioritize finding:
- bugs
- regressions
- broken assumptions
- architecture drift
- missing tests
- upgrade or release risks

Do not treat the review as a style-polish exercise unless the user asks for that explicitly.

## Read First
- `AGENTS.md`
- `docs/PROJECT_OVERVIEW.md`
- `docs/PROJECT_GUIDELINES.md`
- any changed files

## Workflow
1. Inspect the changed files and identify the behavioral surface area.
2. Read the surrounding code, not just the diff hunk.
3. Check whether the change matches existing repo patterns for:
   - feature structure
   - routing
   - Riverpod state handling
   - DTO/entity separation
   - codegen expectations
   - release/versioning workflow
4. Look for risk in:
   - startup/setup code
   - generated-code assumptions
   - notification and Firebase wiring
   - secrets handling
   - build or CI config
   - platform-specific files
5. Check whether tests should have changed.
6. Only after reviewing findings, summarize the overall change briefly.

## Output Format
Present findings first, ordered by severity.

Each finding should include:
- severity
- concise explanation of the problem
- why it matters
- file reference

After findings, optionally include:
- open questions or assumptions
- brief summary of what changed

If there are no findings, say so explicitly and mention any residual risk or untested area.

## Repo-Specific Watch Outs
- Some services in this template are scaffolded but not fully enabled, especially in `lib/app/setup/setup_app.dart`.
- Changes to routes, `@riverpod`, `@freezed`, DTOs, localization, or assets often imply `make gen`.
- Generated files may change as part of legitimate work, but review the source change first.
- Workflow and release file edits can have impact beyond local code behavior.
- Widget tests under `test/` should run under `flutter test`; integration flows under `integration_test/` are separate.

## Good Review Questions
- Does this change break the existing startup assumptions?
- Does it bypass shared use cases or data mapping layers?
- Does it introduce a mismatch between `.fvmrc`, `pubspec.yaml`, CI, or generated files?
- Does it add behavior without adding or updating validation?
- Does it change release, secrets, or notification behavior in a risky way?
