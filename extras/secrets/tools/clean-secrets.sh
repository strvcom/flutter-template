#!/usr/bin/env bash
# Remove all secret files
rm -f android/extras/keystores/release.keystore
rm -f android/extras/keystores/release.properties
rm -f .env
rm -f .env-staging
rm -f .env-production
rm -f .env-development
rm -f ios/Flutter/.env.xcconfig
rm -f ios/Flutter/.env.staging.xcconfig
rm -f ios/Flutter/.env.production.xcconfig
rm -f ios/Flutter/.env.develop.xcconfig
rm -f android/app/google-services.json
rm -f ios/config/develop/GoogleService-Info.plist
rm -f ios/config/production/GoogleService-Info.plist
rm -f ios/config/staging/GoogleService-Info.plist
