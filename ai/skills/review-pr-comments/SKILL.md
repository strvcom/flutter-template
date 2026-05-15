---
name: review-pr-comments
description: >
  Review and resolve PR review comments on the current branch's PR in this Flutter repository,
  from both AI reviewers (CodeRabbit, CodiumAI, CodePilot, Copilot, etc.) and human reviewers.
  Fetches comments via `gh`, splits them into AI and human groups, verifies each comment against
  the actual Flutter code, triages them, proposes fixes, and optionally applies fixes, replies to
  comments, and pushes.
  Use when the user asks to review PR comments, resolve PR feedback, review AI comments, review
  human review comments, or handle code review feedback.
allowed-tools: Agent, Bash, Read, Edit, Write, Grep, Glob
model: claude-sonnet-4-6
---

# Flutter Template Review PR Comments

Handle review feedback on the current PR from both automated AI reviewers and human reviewers. Results are always presented split into **AI** and **Human** sections so the user can read them separately.

## Read First
- `AGENTS.md`
- `docs/PROJECT_OVERVIEW.md`
- `docs/PROJECT_GUIDELINES.md`
- the files referenced by PR comments
- nearby source files when a comment depends on local context

## Preconditions
- The GitHub CLI `gh` must be installed and authenticated.
- The current branch must have an open PR.
- Do not apply fixes, reply to comments, commit, or push until the user approves those actions.

## Step 1: Find the PR

```bash
gh pr list --head "$(git branch --show-current)" --json number,url --jq '.[0]'
```

If no PR is found, inform the user and stop. If `gh` is not available or not authenticated, report the blocker and the command that failed.

## Step 2: Fetch All Review Comments

Extract the owner/repo from `gh repo view --json nameWithOwner --jq '.nameWithOwner'`.

Fetch all PR review comments, including inline comments on code:

```bash
gh api repos/{owner}/{repo}/pulls/{number}/comments --paginate \
  --jq '.[] | {id: .id, user: .user.login, user_type: .user.type, path: .path, line: .line, original_line: .original_line, diff_hunk: .diff_hunk, body: .body}'
```

Also fetch top-level issue-style comments on the PR (some reviewers use these):

```bash
gh api repos/{owner}/{repo}/issues/{number}/comments --paginate \
  --jq '.[] | {id: .id, user: .user.login, user_type: .user.type, body: .body}'
```

Optionally fetch the PR review summaries if the user asks for every review artifact:

```bash
gh api repos/{owner}/{repo}/pulls/{number}/reviews --paginate \
  --jq '.[] | {id: .id, user: .user.login, user_type: .user.type, state: .state, body: .body}'
```

## Step 3: Classify Each Comment — AI vs Human

Split every comment into one of two buckets:

- **AI** — the author login matches a known bot pattern (case-insensitive):
  `coderabbit`, `codiumai`, `codepilot`, `copilot`, `sonarcloud`, `deepsource`, `sourcery`
  OR the GitHub `user.type` is `Bot`.
- **Human** — everything else.

Group comments by reviewer within each bucket (so the user sees "CodeRabbit: 3", "Alice: 2", etc).

If both buckets are empty, inform the user and stop.

## Step 4: Triage Each Comment

For each comment (in both buckets):
1. Read the referenced file and line range to understand the actual code.
2. Read surrounding Flutter template context when needed, especially providers, use cases, route registration, DTO/entity mapping, localization, and generated source inputs.
3. Determine if the issue described actually exists in the current branch.
4. Classify as one of:
   - **Must-Fix**: compile/analyze errors, runtime crashes, broken navigation, data loss, security issues, secrets exposure, invalid generated-code assumptions, or release/build breakage.
   - **Should-Fix**: real bugs, incorrect Riverpod lifecycle handling, bad async/ref usage, DTO/entity mapping mistakes, localization/assets/codegen issues, test failures, or logic errors that affect correctness.
   - **Nice-to-Have**: valid but low-impact suggestions such as naming, readability, small UI polish, or minor refactors that are not required for correctness.
   - **Irrelevant**: false positive, already handled, obsolete/outdated diff context, generated file comment where the source is correct, or not applicable to this Flutter template.

Human comments deserve more deference than AI comments. If a human raised a concern you do not fully understand, surface it to the user rather than classifying it as Irrelevant.

When comments mention source-platform concepts from KMP, Android, or iOS migration work, translate the concern into Flutter terms before deciding. For example, check the destination feature state, use case, route, or widget behavior rather than preserving Kotlin/Swift architecture literally.

## Flutter-Specific Checks
Use these checks when comments touch related code:

- Feature files should follow the repo pattern: `*_page.dart`, `*_page_content.dart`, `*_state.dart`, and `*_event.dart` when state/events are needed.
- Route widgets should use `@RoutePage()` and be registered in `lib/app/navigation/app_router.dart`; generated route files should not be hand-edited.
- Riverpod notifiers should keep IO in use cases, guard page-scoped async follow-up with `ref.mounted`, and use `keepAlive` only for app-scoped state or deliberate async lifetimes.
- DTOs belong in `lib/common/data/dto/`, entities in `lib/common/data/entity/`, and UI should not consume transport models directly.
- Shared UI should prefer `lib/common/component/`, `lib/common/composition/`, `context.colorScheme`, `context.textTheme`, and `context.locale`.
- Localization changes belong in `assets/localization/*.arb` and require generated accessors under `lib/assets/`.
- Generated files such as `*.g.dart`, `*.freezed.dart`, `*.gr.dart`, and `lib/assets/**` should be fixed through their source inputs and `make gen`.
- Firebase, notifications, Remote Config, and startup comments must be checked against `lib/app/setup/setup_app.dart` because some template hooks are scaffolded or disabled.
- Secrets and decrypted environment files should not be modified unless the review comment is explicitly about secrets setup.

## Step 5: Present Findings (Split by AI / Human)

Present results in two clearly labeled sections. Within each, group by severity.

```text
### AI Reviewer Comments
Reviewers: CodeRabbit (3), Copilot (1)

#### Must-Fix
...

#### Should-Fix
...

#### Nice-to-Have
...

#### Irrelevant
...

---

### Human Reviewer Comments
Reviewers: @alice (2), @bob (1)

#### Must-Fix
...

#### Should-Fix
...

#### Nice-to-Have
...

#### Irrelevant
...
```

Each row or bullet includes:
- comment id or stable number from the fetched list
- reviewer login
- file and line when available
- issue summary
- classification
- proposed fix for relevant comments
- reason when classified as Irrelevant

Wait for user confirmation before applying any fixes. The user may respond with per-comment decisions:
- **fix**: apply the proposed fix
- **skip**: leave as-is, no reply needed unless the user asks
- **defer**: reply with a short explanation of why it is deferred
- **reply**: answer the comment without code changes
- **ignore**: for AI comments only; use the reviewer-specific ignore command only when supported, such as `@coderabbitai ignore` for CodeRabbit

Do not use AI ignore commands for human comments.

## Step 6: Apply Fixes (After User Approval)

1. Make only the code changes approved by the user.
2. Keep changes scoped to the commented files and the directly required source inputs.
3. If a generated file would need edits, change the annotated/source file and run `make gen`.
4. Verify the relevant Flutter checks:
   - run `make gen` when annotations, routes, DTOs, localization, or assets changed
   - run `fvm flutter analyze`
   - run `fvm flutter test` when behavior, widgets, state, use cases, or tests changed
   - run `make integration_test` only when Patrol integration flows changed or the user asks for it
5. Commit changes only if the user explicitly approved a commit.
6. Reply to each comment on the PR based on the user's decision:
   - **Fixed** comments: brief description of what was done.
   - **Deferred** comments: explanation of why.
   - **Irrelevant / not applicable** comments: explanation of why it is not applicable.
   - **Ignored** AI comments: reviewer-specific ignore command when supported.

For inline PR review comments, reply with:

```bash
gh api repos/{owner}/{repo}/pulls/{number}/comments/{comment_id}/replies \
  -f body="<reply message>"
```

For top-level issue comments or review summaries, use a normal PR comment when a direct reply endpoint is not available:

```bash
gh pr comment {number} --body "<reply message>"
```

7. Push changes only if the user explicitly approved a push.

## Rules

- Always verify comments against the actual code before accepting them.
- Never blindly apply AI-suggested fixes; they may be wrong or incomplete.
- Give human reviewers' concerns more weight. When uncertain, ask the user rather than dismissing.
- Present findings split by AI / Human before making any changes.
- Do not edit generated files directly. Fix the source and regenerate.
- Do not touch files outside the approved PR-comment scope unless necessary for the approved fix.
- Do not stage, commit, push, or reply to PR comments without user approval.
- Do not preserve KMP, Android, or iOS architecture terms in Flutter code unless the Flutter project already has the equivalent abstraction.
- Leave clear notes for comments that cannot be resolved mechanically or require product/design judgment.
