# Generating new key
To generate new `release.keystore` file, use following command:

```
keytool -genkey -v -keystore release.keystore -keyalg RSA -keysize 2048 -validity 20000 -storetype PKCS12 -alias exampleKeyAlias -storepass examplePassword -keypass examplePassword 
```
Note: The password for store and key must be the same for `PKCS12` storetype.

Here is an example for organizational information that you need to fill during generating of a new key:
```
CN=Joe Doe, OU=STRV, O=STRV, L=Prague, ST=Czechia, C=CZ
```

To get the SHA1 Certificate of the keystore (for example for Firebase purpose) you can use following commands:
```
keytool -list -v -alias android -keystore debug.keystore
keytool -list -v -alias exampleKeyAlias -keystore release.keystore
```

# Release keystore

This repository does not contains release signing keystore in open form.
Instead there is an encrypted file `extras/secrets/release.keystore.enc` containing release keystore and properties.
Therefore if you want to build a release build there is necessary to load those secrets.

## Load/decrypt secrets to local properties

1) Ask developers to share `age_key.txt` secret and keep this secret safe!
2) Export path to that file with `export SOPS_AGE_KEY_FILE="<path to generated file>/age_key.txt"`
3) From the root of the project run the script `make secretsDecrypt` (`sh ./extras/secrets/tools/load-secrets.sh`) which
   will produce proper files with secrets
4) In the folders `./extras/secrets/` and `./extras/keystores/` check files are there and set. The build script will read
   them accordingly during the build.
5) After making changes in decrypted files, run `make secretsEncrypt` (`sh ./extras/secrets/tools/encrypt-secrets.sh`) for encryption.
