import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/common/data/entity/exception/custom_exception.dart';
import 'package:flutter_app/common/data/entity/user_entity.dart';
import 'package:flutter_app/common/usecase/authentication/sign_in_completion_use_case.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_with_auth_credential_use_case.g.dart';

@riverpod
FutureOr<UserEntity> signInWithAuthCredentialUseCase(
  Ref ref, {
  required AuthCredential credential,
}) async {
  final firebaseUser = FirebaseAuth.instance.currentUser;

  Flogger.d('[Authentication] Firebase user $firebaseUser');

  if (firebaseUser != null) {
    // Title: Link existing user with credentials
    Flogger.d('[Authentication] Going to link firebase user with received credential');

    try {
      await firebaseUser.linkWithCredential(credential);

      Flogger.d('[Authentication] Anonymous user was linked with google credential');
    } on Exception catch (error) {
      final customException = CustomException.fromErrorObject(error: error);
      final credentialIsAlreadyInUse = switch (customException) {
        CustomExceptionCredentialAlreadyInUse(credential: final credential) => credential,
        _ => null,
      };

      if (credentialIsAlreadyInUse != null) {
        await FirebaseAuth.instance.signInWithCredential(credentialIsAlreadyInUse);
      } else {
        rethrow;
      }
    }
  } else {
    // Title: Sign in with credentials
    Flogger.d('[Authentication] Going to sign in user with received credential ${credential.asMap()}');

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  return await ref.read(signInCompletionUseCaseProvider.future);
}
