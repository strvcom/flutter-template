#!/bin/sh

set -eu

if [ "$#" -ne 1 ]; then
  echo "Usage: sh ai/skills/flutter-template-release-builds/scripts/archive_ios_ipa.sh <develop|staging|production>" >&2
  exit 1
fi

flavor="$1"

case "$flavor" in
  develop|staging|production)
    ;;
  *)
    echo "Unsupported flavor: $flavor" >&2
    exit 1
    ;;
esac

version="$(sed -n 's/^version: \([^ #][^ #]*\).*/\1/p' pubspec.yaml | head -n 1)"

if [ -z "$version" ]; then
  echo "Could not determine app version from pubspec.yaml" >&2
  exit 1
fi

ipa_matches="$(find build/ios/ipa -maxdepth 1 -type f -name '*.ipa' | sort)"

if [ -z "$ipa_matches" ]; then
  echo "No IPA file found in build/ios/ipa" >&2
  exit 1
fi

ipa_count="$(printf '%s\n' "$ipa_matches" | wc -l | tr -d ' ')"

if [ "$ipa_count" -ne 1 ]; then
  echo "Expected exactly one IPA file in build/ios/ipa, found $ipa_count" >&2
  printf '%s\n' "$ipa_matches" >&2
  exit 1
fi

ipa_path="$ipa_matches"

ipa_name="$(basename "$ipa_path" .ipa)"
destination_dir="release_artifacts/ios-ipa/$version"
destination_path="$destination_dir/${ipa_name}-${flavor}-${version}.ipa"
symbols_source_dir="build/app/outputs/symbols"
symbols_destination_dir="release_artifacts/flutter-symbols/$version/$flavor"

if [ ! -d "$symbols_source_dir" ]; then
  echo "No Flutter obfuscation symbols directory found at $symbols_source_dir" >&2
  exit 1
fi

if [ -z "$(find "$symbols_source_dir" -type f -maxdepth 1 | head -n 1)" ]; then
  echo "No Flutter obfuscation symbol files found in $symbols_source_dir" >&2
  exit 1
fi

mkdir -p "$destination_dir"
cp "$ipa_path" "$destination_path"
rm -rf "$symbols_destination_dir"
mkdir -p "$symbols_destination_dir"
cp "$symbols_source_dir"/* "$symbols_destination_dir"/

echo "Archived IPA to $destination_path"
echo "Archived Flutter obfuscation symbols to $symbols_destination_dir"
