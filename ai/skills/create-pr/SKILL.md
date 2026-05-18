---
name: create-pr
description: >
  Create or update a GitHub PR for this Flutter repository using gh CLI. Verifies the work with
  build-verify and pr-review, generates an inline PR description, commits pending changes when
  approved, pushes, and opens or updates the PR. Supports stacked PRs by asking for the base
  branch when detection is ambiguous. Use when the user says "create PR", "open PR", "push PR",
  or wants to submit their work for review.
allowed-tools: Bash, Read, Write, Grep, Glob, Skill, Agent
user-invocable: true
model: claude-sonnet-4-6
---

# Flutter Template Create Pull Request

Create or update a GitHub PR for the current branch. This workflow may commit and push, so ask before changing branches, committing, or pushing unless the user's request already clearly authorizes those actions.

## Read First
- `AGENTS.md`
- `docs/PROJECT_OVERVIEW.md`
- `docs/PROJECT_GUIDELINES.md`
- `git status`
- relevant task docs under `.claude/tasks/`, when present

## Step 1: Collect PR Metadata

If the user did not provide these when invoking the skill, ask before proceeding:

1. **Type of work**: one of `chore`, `feat`, `fix`, `refactor`
2. **Ticket number**: e.g. `MOB-120`, or confirm that there is no ticket
3. **Short description**: plain-English summary for the commit and PR title

## Step 2: Decide Branch And Base

This repo may use stacked PRs. The PR base is the branch the current branch should merge into, which is not always the default branch.

Try to detect the parent branch:

```bash
git show-branch --all 2>/dev/null \
  | grep '\*' \
  | grep -v "$(git rev-parse --abbrev-ref HEAD)" \
  | head -1 \
  | sed 's/.*\[\(.*\)\].*/\1/' \
  | sed 's/[\^~].*//'
```

Alternative: use `git log --format=%D HEAD --decorate` and pick the nearest branch that is not `HEAD`.

If detection fails or is ambiguous, ask the user which branch this PR should target.

Ask whether to create a new branch or push the current branch unless the user already made that clear:

> Should I create a new branch for these changes, or push to the current branch `<current>`?
> The PR will target `<detected-or-confirmed-base>`.

If creating a new branch, ask for the branch name or derive one from `<type>/<ticket>/<slug>`.

## Step 3: Verify Build And Review

Run the `build-verify` skill:

```bash
.claude/skills/build-verify/scripts/verify.sh
```

It runs the Flutter verification suite for this repo: dependency sync, code generation when needed, analyzer, tests, iOS and Android native builds when in scope, and formatting. If it fails, fix the root cause and re-run before continuing.

After build verification passes, run `pr-review uncommitted` if it has not already been run for the current diff. Address IMPORTANT findings before continuing. If addressing findings changes code, rerun `build-verify` before continuing to the commit step.

## Step 4: Include Task Documentation

Stage and commit relevant files under `.claude/tasks/` when they describe the implemented feature, including `prd.md`, `techspec.md`, `tasks.md`, and individual task files. These are part of the deliverable and should not be left untracked when they document the PR's work.

If the implementation diverged from the original plan, update task docs only if the user or project workflow expects docs to reflect the final implementation. Do not rewrite PRD or tech spec casually during PR creation.

## Step 5: Generate PR Description Inline

Compose the PR body in memory and pass it directly to `gh`. Never write `pr_description.md` or any other temporary PR body file to disk.

Analyze the changes against the confirmed base branch:

```bash
git diff --stat <base>...HEAD
git log <base>..HEAD --oneline
```

Use this format when sections apply:

```markdown
## New Features
- <one short, plain-English bullet describing a user-visible capability>

## Improvements
- <one short bullet per user-visible improvement>

## Refactor
- <one short bullet per architectural or internal cleanup>

## Fixes
- <one short bullet per fixed issue>

## Chores
- <one short bullet per non-user-facing maintenance change>

## Screenshot
TODO
```

For small PRs, skip section headers and write 1-3 concise bullets plus `## Screenshot` when appropriate.

Style:
- One sentence per bullet.
- High-level, not file-by-file.
- Light on jargon. Type names, file paths, provider names, generated route names, and DTO names belong in the diff, not the PR body.
- Keep it to roughly 3-6 bullets.
- Do not include test plans, checklists, screenshots, or architecture deep dives.

## Step 6: Commit Pending Changes

Run `git status` to check for uncommitted changes. If there are pending changes and the user approved committing, stage the intended files and create a commit.

Commit message format:

```text
<type>(<ticket>): <short description>
```

If there is no ticket:

```text
<type>: <short description>
```

Example:

```text
feat(MOB-120): add profile detail screen
```

Add co-author trailers only when the project or user explicitly asks for them.

## Step 7: Push Branch

Push the current branch to remote when the user approved pushing:

```bash
git push -u origin HEAD
```

## Step 8: Create Or Update PR

Create the PR with the confirmed base branch:

```bash
gh pr create --title "<title>" --body "$(cat <<'EOF'
<pr body here>
EOF
)" --base "<base-branch>" --assignee @me
```

If a PR already exists for this branch, update it:

```bash
gh pr edit --title "<title>" --body "$(cat <<'EOF'
<pr body here>
EOF
)" --base "<base-branch>"
```

Title format:

```text
<type>: <ticket> <short description>
```

Example:

```text
feat: MOB-120 add profile detail screen
```

If there is no ticket, omit it from the title.

## Step 9: Report Result

Output:
- PR URL
- base branch
- verification summary
- commit hash, if a commit was created
- push status

## Rules

- Use `fvm`, `make gen`, `build-verify`, and `pr-review`; do not run KMP, Gradle, Spotless, Detekt, Tuist, SwiftLint, or SwiftFormat checks from this workflow.
- Do not write a PR description file to disk.
- Do not hand-edit generated files to make verification pass.
- Do not omit `.claude/tasks/` docs when they describe the implemented feature.
- Do not push or create a PR if verification or IMPORTANT review findings remain unresolved, unless the user explicitly asks to publish a draft with known issues.
