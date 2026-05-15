---
name: pr-review
description: Review pull requests, branch diffs, and uncommitted changes in this Flutter repository with a bug-finding mindset. Use when asked to review changes, review a PR, audit a diff, check standards, check compliance, or look for regressions, missing tests, release risks, or architecture mismatches.
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

## Determine Review Scope
Parse the user's request and choose the smallest matching diff scope.

| User asks for | Review scope |
|:--|:--|
| default, branch review, PR review | `git diff <default_branch>...HEAD` |
| uncommitted changes | `git diff` plus `git diff --cached` |
| a specific commit | `git show <commit>` |
| last N commits | `git diff HEAD~N...HEAD` |
| branch X vs Y | `git diff X...Y` |
| explicit commit range | `git diff <range>` |

Detect the default branch with:

```bash
git symbolic-ref refs/remotes/origin/HEAD | sed 's|refs/remotes/origin/||'
```

If that fails, try `main`, then `master`.

Gather:

```bash
git diff --name-status <range>
git diff --stat <range>
git diff --unified=5 <range>
```

For uncommitted reviews, gather both unstaged and staged diffs. If there are no changes, say so and stop. If there are more than 50 changed files, warn that it is a large review and ask whether to proceed or narrow the scope.

## Classify Changed Files
Classify every non-deleted changed file before reviewing so the right standards are applied. A file can belong to multiple categories.

| Category | File patterns | Review focus |
|:--|:--|:--|
| Feature UI | `lib/features/**/**_page.dart`, `lib/features/**/**_page_content.dart` | page thinness, shared widgets, localization, theme extensions, user-facing states |
| Feature state | `lib/features/**/**_state.dart`, `lib/features/**/**_event.dart` | Riverpod orchestration, async gaps, `freezed` unions, one-off events |
| Navigation | `lib/app/navigation/**`, changed `@RoutePage()` widgets | AutoRoute registration, generated route expectations, deep-link or shell behavior |
| Data and entities | `lib/common/data/dto/**`, `lib/common/data/entity/**`, `lib/common/data/enum/**` | DTO/entity separation, JSON/freezed annotations, resilient mapping |
| Use cases and providers | `lib/common/usecase/**`, `lib/common/provider/**`, `lib/core/**` | IO boundaries, provider lifetimes, startup assumptions, service wiring |
| Theme and shared UI | `lib/app/theme/**`, `lib/common/component/**`, `lib/common/composition/**` | reuse, accessibility, edge-to-edge/system bar behavior, visual consistency |
| Localization and assets | `assets/localization/**`, `pubspec.yaml`, asset inputs | generated accessors, `context.locale`, `make gen` expectations |
| Tests | `test/**`, `integration_test/**` | coverage quality, realistic assertions, Patrol vs widget-test boundaries |
| Platform files | `android/**`, `ios/**`, `web/**`, `macos/**`, `linux/**`, `windows/**` | flavor config, Firebase, signing, native build risks |
| Release and CI | `.github/**`, `makefile`, `release_notes.txt`, `.fvmrc`, `pubspec.yaml` | version alignment, workflow blast radius, release sequencing |
| Migration reference | imported Kotlin/Swift/KMP files, migration notes, copied source snippets | behavior parity only; do not require KMP/iOS style rules in Flutter code |

Skip deleted files, generated files, and generated asset files unless the source change suggests a generation problem. Generated examples include `*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `lib/assets/**`, `.generated.` files, and platform build outputs.

## Workflow
1. Inspect the changed files and classify the behavioral surface area.
2. Read the surrounding code, not just the diff hunk.
3. Apply every relevant repo-specific check for each file category.
4. Check whether the change matches existing repo patterns for:
   - feature structure
   - routing
   - Riverpod state handling
   - DTO/entity separation
   - codegen expectations
   - release/versioning workflow
5. Look for risk in:
   - startup/setup code
   - generated-code assumptions
   - notification and Firebase wiring
   - secrets handling
   - build or CI config
   - platform-specific files
6. Check whether tests should have changed.
7. Only report issues introduced by added or modified lines in the reviewed diff. Use surrounding code to understand the bug, but do not report pre-existing unrelated issues.
8. Only after reviewing findings, summarize the overall change briefly.

## Parallel Review Lanes
When the environment supports parallel review agents and the user has asked for delegated or parallel agent work, split the diff by category and review lanes concurrently. Otherwise, perform the lanes yourself in sequence.

Use only lanes that have matching files:

| Lane | Categories |
|:--|:--|
| Flutter UI | Feature UI, Theme and shared UI, Localization and assets |
| Riverpod architecture | Feature state, Use cases and providers |
| Data flow | Data and entities, Use cases and providers |
| Navigation and startup | Navigation, startup/setup-facing providers, Platform files |
| Tests and release | Tests, Release and CI |
| Migration parity | Migration reference plus the Flutter files that implement the migrated behavior |

Merge lane results by deduplicating identical file/line findings, then sort by severity.

## Output Format
Present findings first, ordered by severity.

Each finding should include:
- severity (`IMPORTANT` for must-fix defects or `NIT` for minor mechanical/style issues)
- concise explanation of the problem
- why it matters
- file reference
- suggested fix

After findings, optionally include:
- open questions or assumptions
- brief summary of what changed
- passed checklist areas, when useful

If there are no findings, say so explicitly and mention any residual risk or untested area.

For standards-style reviews, use this structure:

```text
Standards Review Report
Branch: <branch>
Compared against: <base or range>
Files reviewed: <count>
Review lanes: <lanes>

IMPORTANT Violations
...

NIT Violations
...

Passed Checklists
...
```

## Auto-Fixing NITs
If the user explicitly asks for standards/compliance review with fixes, or asks to apply safe fixes after the report, mechanically auto-fix only unambiguous `NIT` violations.

Do:
- touch only files included in the review scope
- apply the smallest possible edit for each NIT
- leave the working tree unstaged
- list every applied NIT fix

Do not:
- auto-fix `IMPORTANT` findings
- auto-fix ambiguous suggestions
- run broad formatting unless the NIT specifically requires it
- stage or commit fixes

## Repo-Specific Watch Outs
- Some services in this template are scaffolded but not fully enabled, especially in `lib/app/setup/setup_app.dart`.
- Changes to routes, `@riverpod`, `@freezed`, DTOs, localization, or assets often imply `make gen`.
- Generated files may change as part of legitimate work, but review the source change first.
- Workflow and release file edits can have impact beyond local code behavior.
- Widget tests under `test/` should run under `flutter test`; integration flows under `integration_test/` are separate.
- In KMP-to-Flutter migration work, check behavior parity against source material while still enforcing Flutter template architecture.
- Avoid importing KMP/iOS concepts directly into Flutter names or layers unless the destination codebase already has the equivalent abstraction.

## Good Review Questions
- Does this change break the existing startup assumptions?
- Does it bypass shared use cases or data mapping layers?
- Does it introduce a mismatch between `.fvmrc`, `pubspec.yaml`, CI, or generated files?
- Does it add behavior without adding or updating validation?
- Does it change release, secrets, or notification behavior in a risky way?
- Does migrated behavior preserve user-visible flows without leaking source-platform architecture into Flutter?
