import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/common/data/model/user_model.dart';
import 'package:flutter_app/common/usecase/authentication/sign_in_with_oauth_credential_use_case.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'sign_in_with_apple_use_case.g.dart';

// TODO: Enable for Android and web after the domain is registered.
@riverpod
Future<UserModel> signInWithAppleUseCase(Ref ref) async {
  Flogger.d('[Authentication] Sign in with Apple started');

  final rawNonce = generateNonce();
  final bytes = utf8.encode(rawNonce);
  final digest = sha256.convert(bytes);
  final nonce = digest.toString();

  final appleCredential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    nonce: nonce,
  );

  final oauthCredential = OAuthProvider('apple.com').credential(
    idToken: appleCredential.identityToken,
    rawNonce: rawNonce,
    accessToken: appleCredential.authorizationCode,
  );

  Flogger.d('[Authentication] Received credential from Apple: $oauthCredential');

  return await ref.read(
    signInWithOauthCredentialUseCaseProvider(
      credential: oauthCredential,
    ).future,
  );
}
