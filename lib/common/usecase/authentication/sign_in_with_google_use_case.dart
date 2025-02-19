import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/common/data/model/exception/custom_exception.dart';
import 'package:flutter_app/common/data/model/user_model.dart';
import 'package:flutter_app/common/usecase/authentication/sign_in_with_auth_credential_use_case.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_with_google_use_case.g.dart';

@riverpod
Future<UserModel> signInWithGoogleUseCase(Ref ref) async {
  Flogger.d('[Authentication] Sign in with Google started');

  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Step 1: Logout from Current Google account if any
  if (await googleSignIn.isSignedIn()) {
    await googleSignIn.disconnect();
  }

  // Step 2: Sign in with Google
  final googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount == null) throw const CustomException.signInCancelled();

  final googleSignInAuthentication = await googleSignInAccount.authentication;
  final oauthCredential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  Flogger.d('[Authentication] Received credential from Google: $oauthCredential');

  return await ref.read(
    signInWithAuthCredentialUseCaseProvider(
      credential: oauthCredential,
    ).future,
  );
}
