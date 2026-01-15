#!/usr/bin/env bash

# encrypts updated project properties, so they can be stored in git

encrypt() {
  local INPUT="$1"
  local OUTPUT="$2"
  local PARAMETERS="$3"
  
  echo "Encrypting $INPUT with $PARAMETERS"
  sops --encrypt $PARAMETERS "$INPUT" > "$OUTPUT"
}

echo "Encrypting project properties"

encrypt .env extras/secrets/env.enc "--input-type dotenv --output-type dotenv"
encrypt .env-staging extras/secrets/env-staging.enc "--input-type dotenv --output-type dotenv"
encrypt .env-production extras/secrets/env-production.enc "--input-type dotenv --output-type dotenv"
encrypt .env-development extras/secrets/env-development.enc "--input-type dotenv --output-type dotenv"

encrypt android/extras/keystores/release.keystore extras/secrets/release.keystore.enc
encrypt android/extras/keystores/release.properties extras/secrets/release.properties.enc

encrypt android/app/google-services.json extras/secrets/google-services.json.enc

encrypt ios/config/develop/GoogleService-Info.plist extras/secrets/GoogleService-Info-develop.plist.enc
encrypt ios/config/staging/GoogleService-Info.plist extras/secrets/GoogleService-Info-staging.plist.enc
encrypt ios/config/production/GoogleService-Info.plist extras/secrets/GoogleService-Info-production.plist.enc