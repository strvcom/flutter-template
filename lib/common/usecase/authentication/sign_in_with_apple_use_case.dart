import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/common/data/model/user_model.dart';
import 'package:flutter_app/common/usecase/authentication/sign_in_with_auth_credential_use_case.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'sign_in_with_apple_use_case.g.dart';

@riverpod
Future<UserModel> signInWithAppleUseCase(Ref ref) async {
  Flogger.d('[Authentication] Sign in with Apple started');

  // To prevent replay attacks with the credential returned from Apple, we include a nonce in the credential request.
  // When signing in with Firebase, the nonce in the id token returned by Apple, is expected to match the sha256 hash of `rawNonce`.
  final rawNonce = generateNonce();
  final sha256Nonce = sha256.convert(utf8.encode(rawNonce)).toString();

  // webAuthenticationOptions is required on Android and on the Web.
  // TODO(HELU): Configure for Android and web after the domain is registered.
  final appleCredential = await SignInWithApple.getAppleIDCredential(
    nonce: sha256Nonce,
    webAuthenticationOptions: WebAuthenticationOptions(
      clientId: 'com.example.app',
      redirectUri: Uri.parse('https://example.com/auth/callback'),
    ),
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
  );

  final oauthCredential = OAuthProvider('apple.com').credential(
    rawNonce: rawNonce,
    idToken: appleCredential.identityToken,
    accessToken: appleCredential.authorizationCode,
  );

  Flogger.d('[Authentication] Received credential from Apple: $oauthCredential');

  return await ref.read(
    signInWithAuthCredentialUseCaseProvider(
      credential: oauthCredential,
    ).future,
  );
}
