---
name: start-job
description: >
  Top-level orchestrator for Flutter feature implementation. Runs the full uninterrupted pipeline:
  tasks → implement-tasks-sequence → build-verify → pr-review uncommitted. Use after a PRD
  and tech spec are complete. Trigger phrases: "start job", "start the job",
  "run the full pipeline", "do it all", "implement the feature end-to-end".
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, Agent, Skill
user-invocable: true
model: claude-sonnet-4-6
---

# Flutter Template Start Job

Single entry point that runs the post-spec Flutter implementation pipeline. It is designed to be invoked once, with no user input between phases, so the feature goes from "spec approved" to "verified, uncommitted implementation" in one shot.

Use this only after the PRD and tech spec are finished. If another agent or developer is still editing the tech spec, do not start implementation yet.

## Prerequisites

- PRD exists at `.claude/tasks/[feature-name]/prd.md`
- Tech Spec exists at `.claude/tasks/[feature-name]/techspec.md`
- The tech spec is complete and no other agent is actively editing it.
- The current working tree does not contain unresolved conflicts in `.claude/tasks/[feature-name]/`.

If the PRD or techspec is missing, stop and ask the user to run `/prd` and/or `/techspec`
first. If the tech spec appears to be in progress, stop and ask the user to confirm it is ready.

## Pipeline

Run each phase in order. Do NOT ask for user approval between phases. Do NOT commit anything
at any point. If a phase fails hard (cannot proceed), stop and surface to the user.

> **Critical orchestration rule:** when a sub-skill returns control, do not treat its output
> as the end of your turn. You are still inside this `/start-job` orchestrator. Immediately
> invoke the next phase's skill in the same response. Do not stop, do not summarize, do not
> pause for user input between phases. The only valid stops are: (a) hard failure, (b) the
> Final Report after Phase 4.

### Phase 1 — Task Breakdown

Invoke the `tasks` skill. It generates `tasks.md` and individual task files under
`.claude/tasks/[feature-name]/`. No approval prompt.

**After `tasks` returns: do not stop, do not wait for input, do not summarize. Immediately
invoke `implement-tasks-sequence` (Phase 2) in the same response.**

### Phase 2 — Implementation

Invoke the `implement-tasks-sequence` skill. It executes all generated tasks in dependency
order, parallelizing when safe. No per-task builds, tests, or commits — agents only write
code changes.

**After `implement-tasks-sequence` returns: immediately invoke `build-verify` (Phase 3).**

### Phase 3 — Build & Test Verification

Invoke the `build-verify` skill. It runs the Flutter verification suite for this repo: dependency sync, code generation when needed, analyzer, tests, iOS and Android native builds when in scope, and formatting. Fix any failures it surfaces with root-cause changes until everything is green.

**After `build-verify` returns: immediately invoke `pr-review uncommitted` (Phase 4).**

### Phase 4 — Standards Review

Invoke the `pr-review uncommitted` skill. It reviews the actual diff against Flutter template standards after the build/test/analyze gate has passed. Fix any IMPORTANT findings it surfaces outside the review skill, rerun `build-verify`, and then rerun `pr-review uncommitted` until no IMPORTANT findings remain, unless the fix needs user judgment.

**After `pr-review` returns cleanly or only leaves accepted follow-up NITs: produce
the Final Report. This is the only place the pipeline stops on success.**

## Final Report

Output a single consolidated summary:
- Feature name and task count
- Implementation result (which tasks completed, any that were blocked)
- `build-verify` result (✓/✗ per step, with the auto-scope decision repeated)
- `pr-review` result (IMPORTANT/NIT counts and any auto-fixed NITs)
- **Reminder:** nothing has been committed. The user reviews the diff and commits, or
  invokes `create-pr`, on their own terms.

## Rules

- **Never commit.** The entire pipeline leaves the working tree dirty for the user to review.
- **No intermediate approvals.** Uninterrupted execution is the whole point.
- **Do not edit specs.** `start-job` reads PRD and tech spec inputs. It should not rewrite them unless the user explicitly asks.
- **Stop on hard failure.** If a phase cannot proceed (missing spec, repeated build failures,
  an agent reports it cannot implement a task), stop and surface — don't continue on a
  broken base.
- **Do not re-run phases already completed.** If `/start-job` is invoked on a feature that
  already has `tasks.md`, confirm whether to re-generate tasks or pick up from
  implementation.
- **Implementation standards are reviewed after verification (via `/pr-review`).**
  Build/test/lint failures are resolved first; standards findings are handled as the final
  pre-PR review pass.
