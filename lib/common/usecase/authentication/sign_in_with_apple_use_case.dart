import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/common/data/entity/exception/custom_exception.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'sign_in_with_apple_use_case.g.dart';

@riverpod
Future<void> signInWithAppleUseCase(Ref ref) async {
  try {
    Flogger.d('[Authentication] Sign in with Apple started natively: ${Platform.isIOS}');

    if (Platform.isIOS) {
      // To prevent replay attacks with the credential returned from Apple, we include a nonce in the credential request.
      // When signing in with Firebase, the nonce in the id token returned by Apple, is expected to match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final sha256Nonce = sha256.convert(utf8.encode(rawNonce)).toString();

      // Subtitle: Step 1 - Get Apple ID credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        nonce: sha256Nonce,
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );

      final oauthCredential = OAuthProvider(
        'apple.com',
      ).credential(rawNonce: rawNonce, idToken: appleCredential.identityToken, accessToken: appleCredential.authorizationCode);

      Flogger.d('[Authentication] Received credential from Apple: $oauthCredential');

      // Subtitle: Step 2 - Sign in with credentials from provider
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } else {
      final appleProvider = AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');
      await FirebaseAuth.instance.signInWithProvider(appleProvider);
    }
  } on SignInWithAppleAuthorizationException catch (e) {
    Flogger.e('[Authentication] Error during sign in with Apple: $e');
    if (e.code == AuthorizationErrorCode.canceled) {
      throw const CustomException.signInCancelled();
    } else {
      throw CustomException.fromErrorObject(error: e);
    }
  } catch (e) {
    Flogger.e('[Authentication] Error during sign in with Apple: $e');
    throw CustomException.fromErrorObject(error: e);
  }
}
