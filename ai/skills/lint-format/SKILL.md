---
name: lint-format
description: >
  Run Flutter/Dart formatting and static analysis for this repository. Use after completing Dart,
  Flutter, generated-source-input, or project configuration changes; when the user asks to lint,
  format, analyze, or check code style; or when preparing code for a pull request.
allowed-tools: Bash, Read, Grep, Glob
model: claude-sonnet-4-6
---

# Flutter Template Lint and Format

## MANDATORY
Run this skill after completing Flutter/Dart code changes unless a broader verification skill already ran equivalent checks. Never declare code work complete with known formatting or analyzer failures.

## Read First
- `AGENTS.md`
- `docs/PROJECT_GUIDELINES.md`
- `analysis_options.yaml`
- `pubspec.yaml`

## Usage

Run the wrapper script from the repo root:

```bash
ai/skills/lint-format/scripts/lint-format.sh
```

The script auto-detects whether Flutter-relevant files changed. When relevant files changed, it formats changed Dart files and runs a project-wide analyzer pass.

Claude-discovered path:

```bash
.claude/skills/lint-format/scripts/lint-format.sh
```

## Flags

| Flag | What it does |
|:--|:--|
| `all` or `--all` | Format standard Dart source directories even if no changed files are detected, then analyze. |
| `--check` | Check formatting without writing changes, then analyze. |
| `--format-only` | Run only `fvm dart format`. |
| `--analyze-only` | Run only `fvm flutter analyze`. |
| `--help` | Show script usage. |

## What It Runs

| Step | Command |
|:--|:--|
| Format | `fvm dart format <changed Dart files>` |
| Format check | `fvm dart format --set-exit-if-changed <changed Dart files>` |
| Analyze | `fvm flutter analyze` |

The default formatter target is changed non-generated Dart files. It skips generated outputs such as `*.g.dart`, `*.freezed.dart`, `*.gr.dart`, and `lib/assets/**`.

If changed annotations, routes, DTOs, localization, or asset inputs require generated files, run `make gen` before this skill so the analyzer sees the current generated code.

## Feedback Loop

1. Run the script.
2. If formatting changed files, inspect the diff.
3. If analyzer failures appear, fix the underlying source issue.
4. Run `make gen` when the failure points to stale generated code.
5. Re-run the script until all checks pass.
6. Only then declare work complete.

## Prerequisites
- FVM installed and configured for the repo.
- Dependencies fetched with `fvm flutter pub get`.
- Generated files are current when the change touched codegen inputs.

## Rules
- Prefer `fvm dart format` and `fvm flutter analyze` over global Dart or Flutter commands.
- Do not hand-edit generated files to satisfy the analyzer.
- Do not run platform-native Swift, Gradle, Spotless, Detekt, or KMP checks from this skill.
- Do not stage or commit formatting changes automatically.
