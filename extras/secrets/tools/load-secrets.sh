#!/usr/bin/env bash

if [[ ! -z "$SECRETS_ENCRYPT_KEY" ]]; then
  echo "copying secret encrypt key"
  echo "$SECRETS_ENCRYPT_KEY" > ./extras/secrets/age_key.base64
fi

if [[ ! -z "$RELEASE_KEYSTORE" ]]; then
  echo "copying release keystore"
  echo "$RELEASE_KEYSTORE" > ./extras/secrets/release.keystore.base64
fi

if [[ ! -z "$RELEASE_PROPERTIES" ]]; then
  echo "copying release properties"
  echo "$RELEASE_PROPERTIES" > ./extras/secrets/release.properties.base64
fi

if [[ ! -z "$FIREBASE_APP_DISTRIBUTION_SERVICE_ACCOUNT" ]]; then
  echo "copying firebase app distribution service account"
  echo "$FIREBASE_APP_DISTRIBUTION_SERVICE_ACCOUNT" > ./extras/secrets/firebase_app_distribution_service_account.json.base64
fi

# set SOPS_AGE_KEY_FILE environment variable
export SOPS_AGE_KEY_FILE="extras/secrets/age_key.txt"

# decode secrets
./extras/secrets/tools/decode-secrets.sh

# decrypt secrets
./extras/secrets/tools/decrypt-secrets.sh
