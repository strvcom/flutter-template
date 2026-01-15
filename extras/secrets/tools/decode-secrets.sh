#!/usr/bin/env bash

# base64 decode the release github secrets

decode() {
  local INPUT="$1"
  local OUTPUT="$2"
  local OUTPUT_DIR
  OUTPUT_DIR=$(dirname "$OUTPUT")

  mkdir -p "$OUTPUT_DIR"

  echo "Decoding $INPUT"

  if [[ "$(uname)" == "Darwin" ]]; then
    base64 -D < "$INPUT" > "$OUTPUT"
  else
    base64 -d < "$INPUT" > "$OUTPUT"
  fi
}

if [[ -f extras/secrets/age_key.base64 ]]; then
  decode extras/secrets/age_key.base64 extras/secrets/age_key.txt
fi

if [[ -f extras/secrets/release.keystore.base64 ]]; then
  decode extras/secrets/release.keystore.base64 extras/secrets/release.keystore.enc
fi

if [[ -f extras/secrets/release.properties.base64 ]]; then
  decode extras/secrets/release.properties.base64 extras/secrets/release.properties.enc
fi

if [[ -f extras/secrets/firebase_app_distribution_service_account.json.base64 ]]; then
  decode extras/secrets/firebase_app_distribution_service_account.json.base64 android/firebase_app_distribution_service_account.json
fi
