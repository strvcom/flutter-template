import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/common/data/model/exception/custom_exception.dart';
import 'package:flutter_app/common/data/model/user_model.dart';
import 'package:flutter_app/common/usecase/authentication/get_firebase_user_use_case.dart';
import 'package:flutter_app/common/usecase/authentication/sign_in_completion_use_case.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_with_oauth_credential_use_case.g.dart';

@riverpod
FutureOr<UserModel> signInWithOauthCredentialUseCase(
  Ref ref, {
  required OAuthCredential credential,
}) async {
  final firebaseUser = await ref.read(getFirebaseUserUseCaseProvider.future);

  Flogger.d('[Authentication] Firebase user $firebaseUser');

  if (firebaseUser != null) {
    // Title: Link existing user with credentials
    Flogger.d('[Authentication] Going to link firebase user with received credential');

    try {
      await firebaseUser.linkWithCredential(credential);

      Flogger.d('[Authentication] Anonymous user was linked with google credential');
    } on Exception catch (error) {
      final customException = CustomException.fromErrorObject(error: error);
      final credentialIsAlreadyInUse = customException.mapOrNull(credentialAlreadyInUse: (value) => value.credential);

      if (credentialIsAlreadyInUse != null) {
        await FirebaseAuth.instance.signInWithCredential(credentialIsAlreadyInUse);
      } else {
        rethrow;
      }
    }
  } else {
    // Title: Sign in with credential
    Flogger.d('[Authentication] Going to sign in user with received credential ${credential.asMap().toString()}');

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  return await ref.read(signInCompletionUseCaseProvider.future);
}
