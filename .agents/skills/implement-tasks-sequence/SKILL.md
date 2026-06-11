---
name: implement-tasks-sequence
description: >
  Orchestrates implementation of all tasks for a feature using an agent team. Respects task
  dependencies, runs tasks in correct order, parallelizes independent tasks. Does NOT build, run
  tests, or commit at any point — verification is delegated to the caller (typically `/start-job`,
  which runs `build-verify` and `pr-review uncommitted` afterwards).
  Use when the user says "implement all tasks", "run the task sequence", "implement the feature",
  or wants to execute multiple tasks from a task list end-to-end.
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, Agent
model: claude-sonnet-4-6
---

# Implement Tasks Sequence

Orchestrate the full implementation of a feature by executing all tasks from a task list using an
agent team. The flow runs uninterrupted — no per-task builds, no per-task tests, no commits, and
no final verification. Verification is the caller's responsibility (normally `/start-job`, which
runs `build-verify` and then `pr-review uncommitted` after this skill completes).

## Step 1: Load the Task List

Read `.claude/tasks/[feature-name]/tasks.md` to understand:
- All tasks and their phases
- The dependency graph
- Which tasks can run in parallel vs. which must be sequential

## Step 2: Plan Execution Order

Build an execution plan from the dependency graph:
1. Group tasks into **waves** — each wave contains tasks whose dependencies are all satisfied by prior waves.
2. Tasks within the same wave that have **no mutual dependencies** can be dispatched to agents **in parallel**.
3. Tasks that depend on a previous task must wait for it to complete.

Briefly summarize the execution plan (wave count, parallel groups) and proceed — no approval needed.

## Step 3: Execute Each Wave

For each wave, dispatch tasks to agents:

### Per-Task Agent Instructions
Each agent receives:
- The task file (`.claude/tasks/[feature-name]/[num]_task.md`)
- The PRD (`.claude/tasks/[feature-name]/prd.md`)
- The Tech Spec (`.claude/tasks/[feature-name]/techspec.md`)
- Instructions to follow the `/implement` skill workflow for coding conventions and applicable
  skills — **BUT skip all build, test, lint, and commit steps**. Only source code changes should
  be made. Verification is centralized at the end of the sequence.

Explicitly tell each agent:
> Do NOT run builds, do NOT run tests, do NOT run lint-format, do NOT commit. Only write the code
> changes for your assigned task. Verification and commit decisions happen at the end of the
> overall flow.

### Wave Completion Gate
A wave is complete when all tasks in the wave have finished writing their code changes. Since there
is no per-task verification, the gate is just task completion. Do not start the next wave until the
current wave's agents have all returned.

## Step 4: Report Results

Provide a concise summary:
- Which tasks were implemented (list, with a one-line description each)
- Any tasks that could not complete (and why)
- Reminder: nothing has been committed, nothing has been verified — that is the caller's
  responsibility. When invoked by `/start-job`, `build-verify` runs next, followed by
  `pr-review uncommitted`.

## Important Rules

- **No per-task verification.** Do not run builds, tests, or lint between tasks. This slows the
  flow without catching anything the final pass wouldn't catch.
- **No per-task commits.** Everything stays uncommitted until the user reviews and commits.
- **Respect dependencies** — never start a task before its dependencies are done.
- **Parallelize when safe** — tasks in the same wave with no mutual dependencies should run as
  parallel agents.
- **Use worktree isolation** — when running parallel agents, use `isolation: "worktree"` to avoid
  file conflicts. Merge changes back after each wave.
- **Stop on hard failure** — if an agent reports it cannot complete its task (e.g. missing
  context, conflicting changes), stop and surface to the user rather than continuing with a broken
  base.
