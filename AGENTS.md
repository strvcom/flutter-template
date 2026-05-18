# AI Agent Guide

Use this file as the entrypoint for automated work in this repository.

## Read Order
1. `docs/PROJECT_OVERVIEW.md` for the repo map, startup flow, and feature inventory.
2. `docs/PROJECT_GUIDELINES.md` for implementation conventions and workflow defaults.
3. `README.md` for template setup, distribution, and platform-specific background.

## Repo Summary
- This is a Flutter template, not a fully productized app.
- Core stack: `flutter_riverpod`, `riverpod_annotation`, `freezed`, `json_serializable`, `auto_route`, `dio`, Firebase services, and FVM-managed Flutter.
- The app already includes example features, navigation, theming, codegen, localization, notifications, and release scaffolding.
- Some integrations are intentionally scaffolded but not fully enabled yet. Check `lib/app/setup/setup_app.dart` before assuming a service is active.

## Working Defaults
- Keep new screen work inside `lib/features/<feature>/`.
- Prefer the existing file pattern when a feature has state:
  - `*_page.dart`
  - `*_page_content.dart`
  - `*_state.dart`
  - `*_event.dart`
- Keep page widgets thin. Put heavier UI in `*_page_content.dart`.
- Prefer shared widgets and extensions from `lib/common/` before introducing new app-specific primitives.
- Keep network payload models in `lib/common/data/dto/` and map them into entities from `lib/common/data/entity/`.
- Use Riverpod providers and use cases instead of wiring IO directly in widgets.

## Codegen And Commands
- Run `make gen` after changing `@riverpod`, `@freezed`, `@RoutePage`, localization, or generated asset inputs.
- Use `make watch` for continuous code generation when doing annotation-heavy work.
- Do not hand-edit generated files such as `*.g.dart`, `*.freezed.dart`, `*.gr.dart`, or files under `lib/assets/`.
- Preferred validation commands:
  - `fvm flutter analyze`
  - `fvm flutter test`
  - `make gen`

## Safety Notes
- Secrets and environment-specific config exist in encrypted and generated forms. Avoid touching `extras/secrets/` or decrypted `.env*` files unless the task clearly requires it.
- Notifications, Remote Config, and some Firebase wiring are present in the codebase but parts of startup remain commented out in the template.
- Release and signing files exist in the repo. Treat versioning, tags, branch flow, and build scripts as developer-owned unless the task explicitly asks for release work.

## Documentation Rule
- If you learn a stable, repo-specific convention while working, update `docs/PROJECT_OVERVIEW.md` or `docs/PROJECT_GUIDELINES.md` instead of adding duplicate instructions elsewhere.

## Reusable Workflows
Repeatable procedures live as skills under `ai/skills/<name>/SKILL.md`. Each
skill has YAML frontmatter (`name:`, `description:`) so it can be auto-discovered
by AI tools that support skills.

Existing skills:
- `project-setup` — customize a new app from this template (identity, platforms, icons, splash, Firebase/secrets, validation)
- `feature-screen` — add a new route / screen using the existing feature pattern
- `feature-data-flow` — build a full backend-backed feature (DTOs, entities, use cases, state, UI)
- `upgrade` — upgrade Flutter SDK and package dependencies
- `release-prepare` — version bump, release notes, release branch, release PR
- `release-builds` — post-merge Android tags and iOS IPA generation + archival
- `secrets-bootstrap` — safe handling of encrypted secrets and signing material
- `pr-review` — bug-first review of branches / diffs / PRs
- `review-pr-comments` — triage and resolve AI or human GitHub PR feedback
- `create-pr` — verify, commit, push, and create or update a GitHub PR
- `lint-format` — run Flutter/Dart formatting and analyzer checks
- `build-verify` — full build/test/analyze/format pass (codegen + analyze + test, then iOS + Android builds in parallel, then `dart format`); auto-scopes to the diff and leaves the working tree dirty for review
- `start-job` — run the post-spec implementation pipeline (`tasks` → `implement-tasks-sequence` → `build-verify` → `pr-review`)
- `prd` — create a Flutter feature Product Requirements Document under `.claude/tasks/<feature>/prd.md`
- `tasks` — break a PRD + tech spec into discrete, dependency-ordered Flutter implementation tasks under `.claude/tasks/<feature>/` using `ai/templates/task.md` and `ai/templates/task-list.md`
- `implement` — implement one generated Flutter task using the repo architecture and verification rules
- `implement-tasks-sequence` — execute generated task files in dependency order before final verification
- `techspec` — translate a PRD into an implementation-ready Flutter tech spec at `.claude/tasks/<feature>/techspec.md`, grounded in the Riverpod / Freezed / AutoRoute / Dio / Firebase stack

### How AI tools find these skills
- **Codex** reads this `AGENTS.md` and the referenced `ai/skills/<name>/SKILL.md`
  files. When delegating, mention the workflow by name, e.g. *"use the
  feature-data-flow workflow"*.
- **Claude Code** auto-discovers skills through `.claude/skills/<name>` symlinks
  that point at `ai/skills/<name>/`. Each skill is also exposed as a slash
  command at `.claude/commands/<name>.md`, so `/feature-screen`, `/pr-review`,
  `/release-prepare`, etc. work as explicit invocations.

### Creating a new skill
When adding a new repeatable workflow, complete all four steps so both Codex and
Claude can use it:
1. **Author the skill.** Create `ai/skills/<name>/SKILL.md` with YAML frontmatter
   (`name:` matching the folder, `description:` explaining when to use it) and
   the workflow body.
2. **Mention it for Codex.** Add the skill to the "Existing skills" list above.
3. **Expose it to Claude Code (auto-discovery).** Add a symlink:
   `ln -s ../../ai/skills/<name> .claude/skills/<name>`
4. **Add a slash command.** Create `.claude/commands/<name>.md` using one of the
   existing commands as a template — a short frontmatter (`description`,
   `argument-hint`) and a one-line body that invokes the skill, followed by
   `$ARGUMENTS`.
