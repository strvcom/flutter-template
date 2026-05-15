---
name: release-builds
description: Run post-merge release build steps for this repository, including Android tag-driven releases and sequential iOS IPA generation with archival for Transporter upload and Crashlytics deobfuscation. Use after the release PR has been merged.
---

# Flutter Template Release Builds

Use this skill only after the release PR has been merged.

## Read First
- `AGENTS.md`
- `docs/PROJECT_GUIDELINES.md`
- `README.md`
- `pubspec.yaml`
- `makefile`
- `.github/workflows/`
- `ai/skills/release-builds/scripts/archive_ios_ipa.sh`

## Goal
This skill is for the post-merge release-build phase.

It covers:
- Android release triggering by tags
- iOS IPA generation
- archiving IPA files outside the cleaned build folder for Transporter upload
- archiving Flutter obfuscation symbols from `build/app/outputs/symbols` for Crashlytics Dart stack-trace deobfuscation

## Android Release Flow
Android releases are triggered by tags after the release branch work is merged.

Current workflow tag patterns:
- develop Firebase distribution: `v<version>-develop`
- staging Firebase distribution: `v<version>-staging`
- production Firebase distribution: `v<version>-production`
- Play Store production: `v<version>-release`

Before tagging:
1. Confirm the merged commit and intended channel.
2. Confirm the tag pattern matches the target workflow.
3. Create the tag on the correct merged commit.
4. Push the tag and monitor the corresponding GitHub Action.

## iOS Release Flow
iOS release builds are manual and should be done one flavor at a time.

Why:
- each make target runs `make clean`
- each build clears the `build/` directory
- IPA files and Flutter obfuscation symbols must be copied out of `build/` before the next build if you want to keep all generated artifacts

## iOS Build Commands
- develop:
  - `make generateIosDevelopIpa`
- staging:
  - `make generateIosStagingIpa`
- production:
  - `make generateIosProductionIpa`

## iOS Artifact Archival Workflow
Immediately after each IPA build, archive the IPA out of `build/ios/ipa/` and Flutter obfuscation symbols out of `build/app/outputs/symbols` before starting the next build.

Use:

```bash
ai/skills/release-builds/scripts/archive_ios_ipa.sh <flavor>
```

Examples:
- `ai/skills/release-builds/scripts/archive_ios_ipa.sh develop`
- `ai/skills/release-builds/scripts/archive_ios_ipa.sh staging`
- `ai/skills/release-builds/scripts/archive_ios_ipa.sh production`

The script copies the generated IPA into:

```text
release_artifacts/ios-ipa/<version>/
```

and renames it to include the flavor plus the full `pubspec.yaml` version token, including the build number, so multiple release IPAs can coexist even when only the build number changes.

It also copies the Flutter obfuscation symbols into:

```text
release_artifacts/flutter-symbols/<version>/<flavor>/
```

These are the `--split-debug-info` Dart symbol files used for Flutter Crashlytics deobfuscation. They are separate from iOS dSYMs and Android R8/ProGuard `mapping.txt`.

## Recommended iOS Sequence
1. Build one flavor.
2. Archive the IPA and Flutter obfuscation symbols with the helper script.
3. Build the next flavor.
4. Archive that IPA and its symbols too.
5. Repeat until all required IPA files are archived.
6. After all IPA files are safely archived, upload them manually through Transporter.
7. Keep the archived Flutter obfuscation symbols with the release artifacts for Crashlytics deobfuscation.

## Watch Outs
- Do not run multiple iOS make targets back-to-back without archiving.
- Do not assume the last-built IPA still exists in `build/ios/ipa/`.
- Do not assume the last-built Flutter obfuscation symbols still exist in `build/app/outputs/symbols`.
- The archival helper expects exactly one IPA in `build/ios/ipa/` and fails loudly if multiple files are present.
- The archival helper also expects `build/app/outputs/symbols` to exist and contain at least one file.
- Transporter is the handoff point to App Store Connect.
- Android and iOS release flows are intentionally different in this repo.
- Transporter delivery is currently a manual step in this workflow, not an automated repo-integrated step.

## Completion Criteria
- Android tags match the intended workflows
- each iOS IPA is generated one-at-a-time
- each iOS IPA is copied out of the build folder
- each iOS build's Flutter obfuscation symbols are copied out of the build folder
- archived IPA filenames include flavor and the full app version token
- archived Flutter obfuscation symbols are grouped by version and flavor
- the team has a clean handoff path into Transporter
