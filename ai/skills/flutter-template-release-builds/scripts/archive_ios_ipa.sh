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

version="$(sed -n 's/^version: \([0-9][^+ ]*\).*/\1/p' pubspec.yaml | head -n 1)"

if [ -z "$version" ]; then
  echo "Could not determine app version from pubspec.yaml" >&2
  exit 1
fi

ipa_path="$(find build/ios/ipa -maxdepth 1 -type f -name '*.ipa' | head -n 1)"

if [ -z "$ipa_path" ]; then
  echo "No IPA file found in build/ios/ipa" >&2
  exit 1
fi

ipa_name="$(basename "$ipa_path" .ipa)"
destination_dir="release_artifacts/ios-ipa/$version"
destination_path="$destination_dir/${ipa_name}-${flavor}-${version}.ipa"

mkdir -p "$destination_dir"
cp "$ipa_path" "$destination_path"

echo "Archived IPA to $destination_path"
