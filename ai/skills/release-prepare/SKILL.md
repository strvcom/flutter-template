---
name: release-prepare
description: Prepare a release in this repository by bumping the app version, updating release notes, creating a release branch named release/<version>, and preparing the PR for merge before any release builds or tags are created.
---

# Flutter Template Release Prepare

Use this skill when preparing a release branch and PR in this repository.

## Read First
- `AGENTS.md`
- `docs/PROJECT_GUIDELINES.md`
- `README.md`
- `pubspec.yaml`
- `release_notes.txt`

## Goal
This skill is for the pre-build release phase.

It should:
- update the app version
- update `release_notes.txt`
- create or prepare a branch named `release/<version>`
- prepare the release PR

It should not:
- create Android release tags yet
- build Android release artifacts yet
- build iOS IPA files yet

Release builds happen only after the release PR is merged.

## Workflow
1. Confirm the target release version.
2. Update `pubspec.yaml` to that version.
3. Add a matching release-notes section to `release_notes.txt`.
4. Verify that the release branch should be named `release/<version>`.
5. Create or switch to `release/<version>`.
6. Run:
   - `make gen` if required by any included changes
   - `fvm flutter analyze`
   - `fvm flutter test`
7. Prepare the PR targeting the team’s release base branch.
8. Only after the PR is merged should release builds or release tags be created.

## Watch Outs
- Do not create Android tags during the prepare phase.
- Do not build iOS IPA files during the prepare phase.
- Keep release notes consistent with the actual shipped changes.
- If the branch target differs from the repo defaults documented in `README.md`, follow the actual team process.

## Completion Criteria
- version updated
- release notes updated
- branch named `release/<version>`
- PR is ready for review or merge
- no build or tag steps were mixed into this phase
