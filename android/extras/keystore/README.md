# Generating new key
To generate new `release.keystore` file, use following command:

```
keytool -genkey -v -keystore release.keystore -keyalg RSA -keysize 2048 -validity 20000 -storetype PKCS12 -alias exampleKeyAlias -storepass examplePassword -keypass examplePassword 
```
Note: The password for store and key must be the same for `PKCS12` storetype.

Here is an example for organizational information that you need to fill during generating of a new key:
```
CN=Lukas Hermann, OU=STRV, O=STRV, L=Prague, ST=Czechia, C=CZ
```

To get the SHA1 Certificate of the keystore (for example for Firebase purpose) you can use following commands:
```
keytool -list -v -alias android -keystore debug.keystore
keytool -list -v -alias exampleKeyAlias -keystore release.keystore
```