#!/usr/bin/env bash

# Runs Flutter/Dart format and analyzer checks for this repository.
#
# Usage:
#   ./lint_format.sh                 # Auto-detect changed Flutter-relevant files
#   ./lint_format.sh all             # Format standard Dart source directories, then analyze
#   ./lint_format.sh --check         # Check formatting without writing changes, then analyze
#   ./lint_format.sh --format-only   # Run only dart format
#   ./lint_format.sh --analyze-only  # Run only flutter analyze

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: lint_format.sh [auto|all|--all] [--check] [--format-only|--analyze-only]

Default auto mode:
  - formats changed non-generated Dart files
  - runs fvm flutter analyze when Flutter-relevant files changed

Flags:
  all, --all       Format standard Dart source directories, then analyze
  --check          Check formatting without writing changes
  --format-only    Run only fvm dart format
  --analyze-only   Run only fvm flutter analyze
  --help           Show this help
EOF
}

mode="auto"
check_format=false
run_format=true
run_analyze=true

for arg in "$@"; do
    case "$arg" in
        auto)
            mode="auto"
            ;;
        all|--all)
            mode="all"
            ;;
        --check)
            check_format=true
            ;;
        --format-only)
            run_analyze=false
            ;;
        --analyze-only)
            run_format=false
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $arg"
            usage
            exit 1
            ;;
    esac
done

if ! command -v git >/dev/null 2>&1; then
    echo "git not found on PATH."
    exit 1
fi

if ! command -v fvm >/dev/null 2>&1; then
    if [[ -x "$HOME/.pub-cache/bin/fvm" ]]; then
        export PATH="$HOME/.pub-cache/bin:$PATH"
    else
        echo "fvm not found. Install FVM with 'dart pub global activate fvm' or run 'make install'."
        exit 1
    fi
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

is_generated_dart() {
    local file="$1"
    [[ "$file" == *.g.dart ]] ||
        [[ "$file" == *.freezed.dart ]] ||
        [[ "$file" == *.gr.dart ]] ||
        [[ "$file" == lib/assets/* ]]
}

is_flutter_relevant() {
    local file="$1"
    [[ "$file" == *.dart ]] ||
        [[ "$file" == pubspec.yaml ]] ||
        [[ "$file" == pubspec.lock ]] ||
        [[ "$file" == analysis_options.yaml ]] ||
        [[ "$file" == build.yaml ]] ||
        [[ "$file" == assets/localization/* ]] ||
        [[ "$file" == lib/* ]] ||
        [[ "$file" == test/* ]] ||
        [[ "$file" == integration_test/* ]]
}

collect_changed_files() {
    {
        git diff --name-only HEAD 2>/dev/null || git diff --name-only 2>/dev/null || true
        git diff --cached --name-only 2>/dev/null || true
        git ls-files --others --exclude-standard 2>/dev/null || true
    } | sort -u
}

changed_files="$(collect_changed_files)"
has_flutter_changes=false

while IFS= read -r file; do
    if [[ -n "$file" ]] && is_flutter_relevant "$file"; then
        has_flutter_changes=true
        break
    fi
done <<< "$changed_files"

if [[ "$mode" == "auto" && "$has_flutter_changes" == false ]]; then
    echo "No Flutter/Dart-relevant changes detected. Nothing to lint or format."
    exit 0
fi

format_targets=()

if [[ "$mode" == "all" ]]; then
    for dir in lib test integration_test; do
        if [[ -d "$dir" ]]; then
            format_targets+=("$dir")
        fi
    done
else
    while IFS= read -r file; do
        if [[ -z "$file" || "$file" != *.dart || ! -f "$file" ]]; then
            continue
        fi
        if is_generated_dart "$file"; then
            continue
        fi
        format_targets+=("$file")
    done <<< "$changed_files"
fi

format_failed=false
analyze_failed=false

if [[ "$run_format" == true ]]; then
    echo "=== Dart format ==="
    if [[ "${#format_targets[@]}" -eq 0 ]]; then
        echo "No changed non-generated Dart files to format."
    else
        format_cmd=(fvm dart format)
        if [[ "$check_format" == true ]]; then
            format_cmd+=(--set-exit-if-changed)
        fi
        format_cmd+=("${format_targets[@]}")

        if "${format_cmd[@]}"; then
            echo "Dart format: PASSED"
        else
            echo "Dart format: FAILED"
            format_failed=true
        fi
    fi
fi

if [[ "$run_analyze" == true ]]; then
    echo ""
    echo "=== Flutter analyze ==="
    if fvm flutter analyze; then
        echo "Flutter analyze: PASSED"
    else
        echo "Flutter analyze: FAILED"
        analyze_failed=true
    fi
fi

echo ""
echo "=== Summary ==="
if [[ "$run_format" == true ]]; then
    if [[ "$format_failed" == true ]]; then
        echo "Dart format: FAILED"
    else
        echo "Dart format: PASSED"
    fi
fi
if [[ "$run_analyze" == true ]]; then
    if [[ "$analyze_failed" == true ]]; then
        echo "Flutter analyze: FAILED"
    else
        echo "Flutter analyze: PASSED"
    fi
fi

if [[ "$format_failed" == true || "$analyze_failed" == true ]]; then
    exit 1
fi

echo ""
echo "All checks passed."
