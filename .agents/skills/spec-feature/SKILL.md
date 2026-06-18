---
name: spec-feature
description: >
  Top-level orchestrator for Flutter feature specification. Runs the full uninterrupted pipeline:
  prd → techspec → tasks in one shot. Use when the user says "spec a feature", "write a spec for",
  "start feature spec", "plan a feature", or wants to go from idea to implementation-ready tasks
  without typing three separate commands.
allowed-tools: Bash Read Grep Glob Edit Write Agent Skill
user-invocable: true
model: claude-opus-4-7
---

# Flutter Template Spec Feature

Single entry point that runs the full feature specification pipeline from idea to
implementation-ready tasks. It is designed to be invoked once; each sub-skill may pause for
user input during its mandatory clarification steps — that is intentional and correct. After
each sub-skill finishes, this orchestrator automatically invokes the next phase without requiring
the user to type the next command.

Use this when you want to go from a feature idea directly to a full task breakdown, without
manually running `/prd`, `/techspec`, and `/tasks` in sequence.

## Prerequisites

- No existing `prd.md` or `techspec.md` for this feature (or the user has confirmed it is safe
  to overwrite).
- The user can answer clarification questions — both `prd` and `techspec` have mandatory
  interactive clarification steps that will pause the pipeline for user input.

If a PRD and tech spec already exist and are complete, use `/start-job [feature-name]` instead.

## Arguments

Accepts an optional feature name. If provided, pass it to each sub-skill so they can pre-fill
the folder name and skip asking. If omitted, the `prd` sub-skill will determine the feature name
during its workflow.

## Pipeline

Run each phase in order. Between phases, do NOT ask for user approval — the sub-skills themselves
handle all necessary user interaction. If a phase fails hard (the sub-skill reports an
unrecoverable error), stop and surface it to the user.

> **Critical orchestration rule:** when a sub-skill returns control, do not treat its output as
> the end of your turn. You are still inside this `/spec-feature` orchestrator. Immediately
> invoke the next phase's skill in the same response. The only valid stops are:
> (a) a sub-skill's mandatory clarification pause (which is correct — wait for the user, then
> resume), (b) a hard failure, or (c) the Final Report after Phase 3.

### Phase 1 — Product Requirements Document

Invoke the `prd` skill (pass the feature name argument if provided).

The `prd` skill has two mandatory interactive steps: it will ask clarifying questions (Step 1)
and present a plan for confirmation (Step 2). These pauses are correct — wait for user responses.
After the user confirms the plan and `prd` saves `prd.md`, it will return control.

**After `prd` returns (i.e., after `prd.md` has been saved): do not stop, do not wait for
additional input, do not summarize. Immediately invoke `techspec` (Phase 2) in the same
response.**

### Phase 2 — Technical Specification

Invoke the `techspec` skill (pass the feature name argument if provided).

The `techspec` skill has one mandatory interactive step: it will ask technical clarification
questions (Step 3). This pause is correct — wait for user responses. After the user answers and
`techspec` saves `techspec.md`, it will return control.

**After `techspec` returns (i.e., after `techspec.md` has been saved): do not stop, do not wait
for additional input, do not summarize. Immediately invoke `tasks` (Phase 3) in the same
response.**

### Phase 3 — Task Breakdown

Invoke the `tasks` skill (pass the feature name argument if provided).

The `tasks` skill runs without approval prompts and generates `tasks.md` plus individual task
files. When invoked from this orchestrator (not directly by the user), `tasks` must skip its
next-step prompt and return control here.

**After `tasks` returns: produce the Final Report. This is the only place the pipeline stops on
success.**

## Final Report

Output a single consolidated summary:
- Feature name and the folder created under `.claude/tasks/`
- What the PRD captured (problem statement, target platforms, scope boundaries)
- Key technical decisions from the tech spec (state model, data sources, navigation shape, any
  new packages needed)
- Task count, phases, and dependency shape
- **Reminder:** the feature is now ready for implementation. Run `/start-job [feature-name]` to
  execute the implementation pipeline, or step through manually with `/implement-tasks-sequence`.

## Rules

- **Never commit.** This pipeline only produces spec and task files.
- **Never skip sub-skill clarification steps.** The mandatory interactive steps in `prd` and
  `techspec` exist to capture requirements accurately. Do not bypass or pre-answer them.
- **Do not edit generated specs.** After `prd` or `techspec` writes a file, do not rewrite it
  as the orchestrator. Only the sub-skill owns its output.
- **Stop on hard failure.** If a phase cannot proceed (missing context, the sub-skill reports an
  unrecoverable error), stop and surface the issue to the user — do not continue on a broken base.
- **Pass the feature name through.** If an argument was provided, pass it consistently to all
  three sub-skills so the folder name stays stable across phases.
