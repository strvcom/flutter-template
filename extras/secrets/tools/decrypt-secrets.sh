#!/usr/bin/env bash

# decrypts ASK_ANGEL properties and signing keys if available

decrypt() {
  local INPUT="$1"
  local OUTPUT="$2"
  local PARAMETERS="$3"

  local OUTPUT_DIR
  OUTPUT_DIR=$(dirname "$OUTPUT")

  mkdir -p "$OUTPUT_DIR"

  echo "Decrypting $INPUT with $PARAMETERS"
  sops --decrypt $PARAMETERS "$INPUT" > "$OUTPUT"
}

# these should be checked-out in git
echo "Decrypting project properties"

decrypt extras/secrets/env.enc .env "--input-type dotenv --output-type dotenv"
decrypt extras/secrets/env-staging.enc .env-staging "--input-type dotenv --output-type dotenv"
decrypt extras/secrets/env-production.enc .env-production "--input-type dotenv --output-type dotenv"
decrypt extras/secrets/env-development.enc .env-development "--input-type dotenv --output-type dotenv"

decrypt extras/secrets/env.enc ios/Flutter/.env.xcconfig "--input-type dotenv --output-type dotenv"
decrypt extras/secrets/env-staging.enc ios/Flutter/.env.staging.xcconfig "--input-type dotenv --output-type dotenv"
decrypt extras/secrets/env-production.enc ios/Flutter/.env.production.xcconfig "--input-type dotenv --output-type dotenv"
decrypt extras/secrets/env-development.enc ios/Flutter/.env.develop.xcconfig "--input-type dotenv --output-type dotenv"

# Android release keystore and properties 
if [[ -f extras/secrets/release.keystore.enc ]]; then
  decrypt extras/secrets/release.keystore.enc android/extras/keystores/release.keystore
fi

if [[ -f extras/secrets/release.properties.enc ]]; then
  decrypt extras/secrets/release.properties.enc android/extras/keystores/release.properties
fi

# Android GoogleService-Info.plist files
if [[ -f extras/secrets/google-services.json.enc ]]; then
  decrypt extras/secrets/google-services.json.enc android/app/google-services.json "--input-type json --output-type json"
fi

# iOS GoogleService-Info.plist files
if [[ -f extras/secrets/GoogleService-Info-develop.plist.enc ]]; then
  decrypt extras/secrets/GoogleService-Info-develop.plist.enc ios/config/develop/GoogleService-Info.plist
fi

if [[ -f extras/secrets/GoogleService-Info-staging.plist.enc ]]; then
  decrypt extras/secrets/GoogleService-Info-staging.plist.enc ios/config/staging/GoogleService-Info.plist
fi

if [[ -f extras/secrets/GoogleService-Info-production.plist.enc ]]; then
  decrypt extras/secrets/GoogleService-Info-production.plist.enc ios/config/production/GoogleService-Info.plist
fi
