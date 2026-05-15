---
name: build-verify
description: >
  Build/test/lint verification pass for this Flutter app — runs codegen, analyze, test,
  then iOS + Android native builds in parallel, then `dart format`. Does NOT commit
  anything; leaves the working tree dirty so the user can review and commit on demand.
  Used at the end of the prd → techspec → tasks → implement-tasks-sequence flow before
  `pr-review`, and can also be invoked manually when the user says "verify build", "run
  full verification", or "check everything".
allowed-tools: Bash, Read, Grep, Glob, Edit, Skill
model: claude-sonnet-4-6
---

# Build Verify

Run the full verification suite once after all implementation work is done. This replaces
per-task verification — the implementation flow is uninterrupted and centralizes all
build / test / analyze / format checks here.

## Usage

Run the orchestrator script:

```bash
.claude/skills/build-verify/scripts/verify.sh
```

It runs the **Dart phase** (codegen + analyze + test) sequentially with fail-fast, then
runs the **iOS** and **Android** native builds **in parallel**, then `dart format` once
both have passed.

By default the script **auto-scopes** based on what changed (committed vs `${BASE_REF:-main}`
plus uncommitted). Auto-scoping skips irrelevant work so small, single-platform changes
aren't forced to build everything:

| Diff shape                                                  | Auto-behavior                          |
|:------------------------------------------------------------|:---------------------------------------|
| All changes under `ios/` only                               | Skip Android native build              |
| All changes under `android/` only                           | Skip iOS native build                  |
| All changes under `test/` only                              | Skip both native builds                |
| No annotation- or pubspec-relevant changes                  | Skip `make gen` codegen                |
| Mixed, empty, or no diff                                    | Run everything                         |

The auto-scope decision is printed at the top of the run so it's never silent.

### Flags

| Flag               | What it does                                                                  |
|:-------------------|:------------------------------------------------------------------------------|
| `--full`           | Disable auto-scoping — run everything regardless of diff                      |
| `--skip-gen`       | Explicitly skip `make gen` (assume codegen is current — also disables auto-scope) |
| `--skip-builds`    | Skip native iOS + Android builds (only run Dart phase + format)               |
| `--ios-only`       | Run only the iOS native build (still runs Dart phase; also disables auto-scope) |
| `--android-only`   | Run only the Android native build (still runs Dart phase; also disables auto-scope) |

### Environment

| Var       | Default            | Used for                                              |
|:----------|:-------------------|:------------------------------------------------------|
| `FLAVOR`  | `develop`          | Flutter build flavor + entrypoint (`lib/main_$FLAVOR.dart`) |
| `BASE_REF`| auto-detected      | Branch to diff against for auto-scoping               |

Example: `FLAVOR=staging ./.claude/skills/build-verify/scripts/verify.sh`.

## What each phase does

**Dart phase** — sequential, fail-fast (runs from the repo root):

1. `fvm flutter pub get` (always — cheap and ensures deps are in sync).
2. `make gen` — unless `--skip-gen` or auto-skipped. Runs `flutter gen-l10n` and
   `dart run build_runner build --delete-conflicting-outputs`.
3. `fvm flutter analyze`.
4. `fvm flutter test`.

**Native builds** — both run in parallel after the Dart phase passes:

- iOS: `fvm flutter build ios --no-codesign --flavor "$FLAVOR" -t "lib/main_$FLAVOR.dart"`
- Android: `fvm flutter build apk --debug --flavor "$FLAVOR" -t "lib/main_$FLAVOR.dart"`

Both verify compilation on each platform; iOS skips codesigning so it doesn't need
provisioning profiles, and Android uses the debug variant so it doesn't need a release
keystore.

**Format** — runs after native builds pass: `fvm dart format lib test`. This
auto-rewrites files; the script reports how many files changed so the user can review.

## Output

Each native track writes to its own log under a temp directory. On success, only a short
summary is printed. On failure, the last 150 lines of the failing track's log are printed
and the full log path is included for inspection.

Report a concise summary to the user:
- Pub get / codegen: `[OK]` / `[SKIPPED]`
- Analyze: `[OK]` / `[FAIL]`
- Test: `[OK]` / `[FAIL]`
- iOS build: `[OK]` / `[FAIL]` / `[SKIPPED]`
- Android build: `[OK]` / `[FAIL]` / `[SKIPPED]`
- Format: `[OK]` (and how many files were auto-formatted, if any)

Remind the user that **nothing has been committed** — they can now run `pr-review`,
review and commit manually, or invoke `create-pr` when ready.

## Failure Handling

If the script exits non-zero:
1. Read the printed log tail carefully; open the full log if needed.
2. Fix the underlying issue in the source code. Do NOT disable checks, skip tests, or
   paper over the issue.
3. Re-run. If only one native track failed, you can re-run just that track with
   `--ios-only` / `--android-only` to save time — but always do a full `verify.sh` run
   before declaring done.

If a step fails repeatedly (3+ attempts) and the fix is not obvious, stop and report the
failure to the user rather than continuing.

## Rules

- **Never commit.** Even if format auto-rewrites files, leave them uncommitted.
- **Never skip phases silently.** The script prints its auto-scope decision; include that
  line in the summary you report to the user so they know what ran vs. what was skipped.
  If you use explicit flags (`--ios-only` / `--android-only` / `--skip-gen` /
  `--skip-builds` / `--full`), say so explicitly as well.
- **Trust the auto-scope default.** Don't reach for `--full` unless you actually need to
  validate cross-platform or you've changed shared infra (e.g. `pubspec.yaml`, theming,
  routing) the auto-scoper can't classify.
- **Root-cause fixes only.** Don't suppress warnings with `// ignore:` or `dynamic`,
  and don't disable a test to make verification pass.
- **Use FVM.** All Flutter / Dart invocations go through `fvm` so the pinned SDK in
  `.fvmrc` is used. The script checks for `fvm` and exits early if it isn't on `PATH`.
