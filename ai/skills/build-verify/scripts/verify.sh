#!/bin/bash

# Description:
# Build / test / analyze / format verification for this Flutter app.
#
# Sequence:
#   1. Dart phase (sequential, fail-fast):
#        fvm flutter pub get
#        make gen                     (unless --skip-gen or auto-skipped)
#        fvm flutter analyze
#        fvm flutter test
#   2. Native builds (parallel, after Dart phase passes):
#        iOS:     fvm flutter build ios --no-codesign --flavor "$FLAVOR" -t lib/main_$FLAVOR.dart
#        Android: fvm flutter build apk --debug --flavor "$FLAVOR" -t lib/main_$FLAVOR.dart
#   3. Format (sequential, after native builds pass):
#        fvm dart format lib test
#
# By default the script auto-scopes based on what changed (committed vs default branch +
# uncommitted):
#   - All changes under ios/ only            -> skip Android native build
#   - All changes under android/ only        -> skip iOS native build
#   - All changes under test/ only           -> skip both native builds
#   - No annotation / pubspec / l10n changes -> skip `make gen` codegen
#   - Mixed or no diff                       -> run everything
#
# Usage:
#   ./verify.sh                       # Auto-scoped verify (default)
#   ./verify.sh --full                # Force-run everything (no auto-skip)
#   ./verify.sh --skip-gen            # Skip `make gen` codegen (explicit)
#   ./verify.sh --skip-builds         # Skip native iOS + Android builds
#   ./verify.sh --ios-only            # Only run the iOS native build
#   ./verify.sh --android-only        # Only run the Android native build
#
# Environment:
#   FLAVOR    default: develop   build flavor + entrypoint (lib/main_$FLAVOR.dart)
#   BASE_REF  auto-detected      branch to diff against for auto-scoping

set -euo pipefail

# Short-circuit --help / -h before doing anything else (so the help works even
# if fvm or git isn't installed yet).
for arg in "$@"; do
    case "$arg" in
        -h|--help)
            sed -n '3,36p' "$0"
            exit 0
            ;;
    esac
done

SKIP_GEN=0
SKIP_BUILDS=0
IOS_ONLY=0
ANDROID_ONLY=0
FULL=0

# Parse flags first so typos error with "Unknown flag" before we complain about
# missing prerequisites like fvm or git.
for arg in "$@"; do
    case "$arg" in
        --full) FULL=1 ;;
        --skip-gen) SKIP_GEN=1 ;;
        --skip-builds) SKIP_BUILDS=1 ;;
        --ios-only) IOS_ONLY=1 ;;
        --android-only) ANDROID_ONLY=1 ;;
        -h|--help) ;; # handled above before prerequisites
        *)
            echo "Unknown flag: $arg" >&2
            exit 2
            ;;
    esac
done

if [ $IOS_ONLY -eq 1 ] && [ $ANDROID_ONLY -eq 1 ]; then
    echo "ERROR: --ios-only and --android-only are mutually exclusive." >&2
    exit 2
fi

# --- Prerequisites -------------------------------------------------------
if ! command -v git >/dev/null 2>&1; then
    echo "ERROR: git not found on PATH." >&2
    exit 1
fi
if ! command -v fvm >/dev/null 2>&1; then
    if [ -x "$HOME/.pub-cache/bin/fvm" ]; then
        export PATH="$HOME/.pub-cache/bin:$PATH"
    else
        echo "ERROR: fvm not found on PATH. Install it with: dart pub global activate fvm" >&2
        echo "       (or see the project README / Makefile 'install' target.)" >&2
        exit 1
    fi
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

detect_default_branch() {
    local branch
    branch="$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||' || true)"
    if [ -n "$branch" ]; then
        if git rev-parse --verify "$branch" >/dev/null 2>&1; then
            echo "$branch"
            return
        fi
        if git rev-parse --verify "origin/$branch" >/dev/null 2>&1; then
            echo "origin/$branch"
            return
        fi
        echo "$branch"
        return
    fi
    if git rev-parse --verify main >/dev/null 2>&1; then
        echo "main"
        return
    fi
    if git rev-parse --verify origin/main >/dev/null 2>&1; then
        echo "origin/main"
        return
    fi
    if git rev-parse --verify master >/dev/null 2>&1; then
        echo "master"
        return
    fi
    if git rev-parse --verify origin/master >/dev/null 2>&1; then
        echo "origin/master"
        return
    fi
    echo "main"
}

BASE_REF="${BASE_REF:-$(detect_default_branch)}"
FLAVOR="${FLAVOR:-develop}"

# Sanity: flavor entrypoint exists.
if [ ! -f "$REPO_ROOT/lib/main_$FLAVOR.dart" ]; then
    echo "ERROR: lib/main_$FLAVOR.dart not found. Set FLAVOR to one of: develop, staging, production." >&2
    exit 2
fi

# --- Auto-scope detection ------------------------------------------------
# Runs unless --full or any explicit narrowing flag is set.
EXPLICIT_SCOPE=0
if [ $IOS_ONLY -eq 1 ] || [ $ANDROID_ONLY -eq 1 ] || [ $SKIP_GEN -eq 1 ] || [ $SKIP_BUILDS -eq 1 ]; then
    EXPLICIT_SCOPE=1
fi

AUTO_MSG=""
if [ $FULL -eq 0 ] && [ $EXPLICIT_SCOPE -eq 0 ]; then
    # Collect changed paths: committed-on-branch vs base + uncommitted tracked + staged + untracked.
    CHANGED="$(
      {
        git diff --name-only "$BASE_REF"...HEAD 2>/dev/null || true
        git diff --name-only 2>/dev/null || true
        git diff --cached --name-only 2>/dev/null || true
        git ls-files --others --exclude-standard 2>/dev/null || true
      } | sort -u
    )"

    # Filter out tooling / doc / generated paths that don't affect builds.
    RELEVANT="$(printf '%s\n' "$CHANGED" \
        | grep -Ev '^(\.claude/|ai/|docs/|\.github/|README|\.gitignore$|\.editorconfig$|\.fvmrc$|\.vscode/|\.idea/)' \
        | grep -Ev '\.(g|freezed|gr|gen|config)\.dart$' \
        | grep -Ev '^lib/assets/' \
        || true)"

    if [ -z "$RELEVANT" ]; then
        AUTO_MSG="no build-relevant changes detected; running everything (use explicit flags to narrow)"
    else
        HAS_IOS=0
        HAS_ANDROID=0
        HAS_DART=0
        HAS_TEST=0
        HAS_NON_TEST=0
        HAS_CODEGEN_INPUT=0

        while IFS= read -r path; do
            [ -z "$path" ] && continue
            case "$path" in
                ios/*) HAS_IOS=1; HAS_NON_TEST=1 ;;
                android/*) HAS_ANDROID=1; HAS_NON_TEST=1 ;;
                test/*) HAS_TEST=1 ;;
                lib/*) HAS_DART=1; HAS_NON_TEST=1 ;;
                pubspec.yaml|pubspec.lock) HAS_DART=1; HAS_CODEGEN_INPUT=1; HAS_NON_TEST=1 ;;
                assets/localization/*) HAS_CODEGEN_INPUT=1; HAS_NON_TEST=1 ;;
                analysis_options.yaml) HAS_NON_TEST=1 ;;
                *) HAS_NON_TEST=1 ;;
            esac
            # Any lib/*.dart edit (non-generated, filtered above) is a potential codegen input.
            case "$path" in
                lib/*.dart|lib/**/*.dart) HAS_CODEGEN_INPUT=1 ;;
            esac
        done <<< "$RELEVANT"

        # Test-only diff -> skip native builds.
        if [ $HAS_TEST -eq 1 ] && [ $HAS_NON_TEST -eq 0 ]; then
            SKIP_BUILDS=1
            AUTO_MSG="all changes are test-only; skipping native builds"
        else
            # Single-platform native changes -> skip the other platform's native build.
            if [ $HAS_IOS -eq 1 ] && [ $HAS_ANDROID -eq 0 ] && [ $HAS_DART -eq 0 ]; then
                IOS_ONLY=1
                AUTO_MSG="all changes are iOS-only; skipping Android native build"
            elif [ $HAS_ANDROID -eq 1 ] && [ $HAS_IOS -eq 0 ] && [ $HAS_DART -eq 0 ]; then
                ANDROID_ONLY=1
                AUTO_MSG="all changes are Android-only; skipping iOS native build"
            fi
        fi

        # No codegen inputs touched -> skip `make gen`.
        if [ $HAS_CODEGEN_INPUT -eq 0 ]; then
            SKIP_GEN=1
            if [ -n "$AUTO_MSG" ]; then
                AUTO_MSG="$AUTO_MSG; no codegen inputs changed, skipping make gen"
            else
                AUTO_MSG="no codegen inputs changed, skipping make gen"
            fi
        fi
    fi
fi

LOG_DIR="$(mktemp -d -t build-verify-XXXXXX)"
DART_LOG="$LOG_DIR/dart.log"
IOS_LOG="$LOG_DIR/ios.log"
ANDROID_LOG="$LOG_DIR/android.log"
FMT_LOG="$LOG_DIR/format.log"

echo "=== build-verify ==="
echo "  flavor: $FLAVOR  (entrypoint: lib/main_$FLAVOR.dart)"
echo "  base: $BASE_REF"
if [ -n "$AUTO_MSG" ]; then
    echo "  auto-scope: $AUTO_MSG"
fi
echo "  dart log: $DART_LOG"
if [ $SKIP_BUILDS -eq 0 ]; then
    [ $ANDROID_ONLY -eq 0 ] && echo "  iOS log: $IOS_LOG"
    [ $IOS_ONLY -eq 0 ] && echo "  Android log: $ANDROID_LOG"
fi
echo ""

overall_start=$(date +%s)

# --- Dart phase ----------------------------------------------------------
dart_start=$(date +%s)
DART_EXIT=0
GEN_STATUS="SKIPPED"
{
    set -e
    echo "[dart] fvm flutter pub get"
    fvm flutter pub get

    if [ $SKIP_GEN -eq 0 ]; then
        echo "[dart] make gen"
        if make -n gen >/dev/null 2>&1; then
            make gen
        else
            echo "  Makefile 'gen' target not found; falling back to inline codegen."
            fvm flutter gen-l10n \
                --arb-dir "assets/localization" \
                --template-arb-file "app_en.arb" \
                --output-localization-file "app_localizations.gen.dart" \
                --output-dir "lib/assets"
            fvm dart run build_runner build --delete-conflicting-outputs
        fi
    else
        echo "[dart] make gen SKIPPED"
    fi

    echo "[dart] fvm flutter analyze"
    fvm flutter analyze

    echo "[dart] fvm flutter test"
    fvm flutter test
} > "$DART_LOG" 2>&1 || DART_EXIT=$?
dart_done=$(date +%s)
dart_s=$(( dart_done - dart_start ))

if [ $SKIP_GEN -eq 0 ]; then
    GEN_STATUS="OK"
fi

if [ $DART_EXIT -ne 0 ]; then
    echo "  [FAIL] Dart phase (${dart_s}s, exit $DART_EXIT)"
    echo ""
    echo "--- Dart log tail (last 150 lines) ---"
    tail -n 150 "$DART_LOG"
    echo "--- full Dart log: $DART_LOG ---"
    exit 1
fi
echo "  [OK]   Dart phase (${dart_s}s)  (codegen: $GEN_STATUS)"
echo ""

# --- Native builds (parallel) --------------------------------------------
IOS_PID=""
ANDROID_PID=""
IOS_EXIT=0
ANDROID_EXIT=0
ios_done=$dart_done
android_done=$dart_done
native_start=$(date +%s)

if [ $SKIP_BUILDS -eq 0 ]; then
    if [ $ANDROID_ONLY -eq 0 ]; then
        (
            set -e
            echo "[iOS] fvm flutter build ios --no-codesign --flavor $FLAVOR"
            fvm flutter build ios --no-codesign --flavor "$FLAVOR" -t "lib/main_$FLAVOR.dart"
        ) > "$IOS_LOG" 2>&1 &
        IOS_PID=$!
        echo "  iOS started (pid $IOS_PID)"
    fi

    if [ $IOS_ONLY -eq 0 ]; then
        (
            set -e
            echo "[Android] fvm flutter build apk --debug --flavor $FLAVOR"
            fvm flutter build apk --debug --flavor "$FLAVOR" -t "lib/main_$FLAVOR.dart"
        ) > "$ANDROID_LOG" 2>&1 &
        ANDROID_PID=$!
        echo "  Android started (pid $ANDROID_PID)"
    fi

    if [ -n "$IOS_PID" ] || [ -n "$ANDROID_PID" ]; then
        echo ""
    fi

    if [ -n "$IOS_PID" ]; then
        wait "$IOS_PID" || IOS_EXIT=$?
        ios_done=$(date +%s)
    fi
    if [ -n "$ANDROID_PID" ]; then
        wait "$ANDROID_PID" || ANDROID_EXIT=$?
        android_done=$(date +%s)
    fi

    ios_s=$(( ios_done - native_start ))
    android_s=$(( android_done - native_start ))

    if [ -n "$IOS_PID" ]; then
        if [ $IOS_EXIT -eq 0 ]; then
            echo "  [OK]   iOS (${ios_s}s)"
        else
            echo "  [FAIL] iOS (${ios_s}s, exit $IOS_EXIT)"
        fi
    fi
    if [ -n "$ANDROID_PID" ]; then
        if [ $ANDROID_EXIT -eq 0 ]; then
            echo "  [OK]   Android (${android_s}s)"
        else
            echo "  [FAIL] Android (${android_s}s, exit $ANDROID_EXIT)"
        fi
    fi
    echo ""

    if [ $IOS_EXIT -ne 0 ] || [ $ANDROID_EXIT -ne 0 ]; then
        if [ $IOS_EXIT -ne 0 ]; then
            echo "--- iOS log tail (last 150 lines) ---"
            tail -n 150 "$IOS_LOG"
            echo "--- full iOS log: $IOS_LOG ---"
            echo ""
        fi
        if [ $ANDROID_EXIT -ne 0 ]; then
            echo "--- Android log tail (last 150 lines) ---"
            tail -n 150 "$ANDROID_LOG"
            echo "--- full Android log: $ANDROID_LOG ---"
            echo ""
        fi
        exit 1
    fi
else
    echo "  Native builds SKIPPED"
    echo ""
fi

# --- Format --------------------------------------------------------------
echo "=== Format ==="
before_fmt="$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
fvm dart format lib test 2>&1 | tee "$FMT_LOG"
after_fmt="$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
fmt_delta=$(( after_fmt - before_fmt ))
if [ "$fmt_delta" -gt 0 ]; then
    echo "  [OK]   Format auto-rewrote files ($fmt_delta new entries in git status). Review before committing."
else
    echo "  [OK]   Format produced no changes."
fi

total_elapsed=$(( $(date +%s) - overall_start ))
echo ""
echo "build-verify completed successfully in ${total_elapsed}s."
echo "Nothing has been committed. Run pr-review or create-pr when ready."
