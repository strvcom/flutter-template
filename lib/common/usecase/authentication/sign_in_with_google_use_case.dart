import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/common/data/entity/exception/custom_exception.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_with_google_use_case.g.dart';

const List<String> _scopes = <String>[
  'email',
];

@riverpod
Future<void> signInWithGoogleUseCase(Ref ref) async {
  try {
    Flogger.d('[Authentication] Sign in with Google started');

    final googleSignIn = GoogleSignIn.instance;

    // Subtitle: Step 1 - Logout from Current Google account if any
    await googleSignIn.disconnect();

    // Subtitle: Step 2 - Authenticate user with Google
    final account = await googleSignIn.authenticate();

    // Subtitle: Step 3 - Authorize scopes
    var authorization = await account.authorizationClient.authorizationForScopes(_scopes);
    authorization ??= await account.authorizationClient.authorizeScopes(_scopes);

    // Subtitle: Step 4 - Create OAuth credential for Firebase
    final oauthCredential = GoogleAuthProvider.credential(
      accessToken: authorization.accessToken,
      idToken: account.authentication.idToken,
    );

    Flogger.d('[Authentication] Received credential: $oauthCredential');

    // Subtitle: Step 5 - Sign in with credentials from provider
    await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  } on GoogleSignInException catch (e) {
    if (e.code == GoogleSignInExceptionCode.canceled) {
      throw const CustomException.signInCancelled();
    } else {
      throw CustomException.fromErrorObject(error: e);
    }
  } catch (e) {
    throw CustomException.fromErrorObject(error: e);
  }
}
