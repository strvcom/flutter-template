---
name: secrets-bootstrap
description: Safely work with encrypted secrets, environment files, and signing material in this repository. Use when a task requires loading, decrypting, validating, or explaining the repo's secrets and signing setup.
---

# Flutter Template Secrets Bootstrap

Use this skill when a task requires secret handling in this repository.

## Read First
- `AGENTS.md`
- `README.md`
- `extras/secrets/tools/`
- `android/extras/keystores/README.md`
- `makefile`

## Safety Rule
Do not touch secrets unless the task clearly requires it.

That includes:
- `.env`
- `.env-development`
- `.env-staging`
- `.env-production`
- keystore files
- encrypted secret files in `extras/secrets/`
- generated iOS config files

## Workflow
1. Confirm why secret access is needed.
2. Inspect the existing secret-loading scripts instead of improvising commands.
3. Prefer existing make targets and scripts:
   - `make secretsDecrypt`
   - `make secretsEncrypt`
   - `make secretsClean`
4. Keep encrypted files and generated decrypted files conceptually separate.
5. Avoid logging secret values in output, comments, or diffs.
6. If a task only needs to know whether a value exists, verify presence without printing contents.

## Repo Notes
- Secret tooling lives under `extras/secrets/tools/`.
- README documents the expected `age` and `sops` flow.
- Android keystore guidance has its own README.
- Environment files are referenced by `pubspec.yaml` and loaded by flavor in `lib/app/setup/setup_app.dart`.

## When To Stop And Ask
- the task needs a missing secret
- the task would rotate or overwrite encrypted files
- the task would expose secret contents in logs or committed files
- the task needs signing or distribution credentials that are not already available

## Completion Criteria
- used existing scripts or make targets where possible
- avoided exposing sensitive values
- explained clearly what was loaded, generated, or still missing
