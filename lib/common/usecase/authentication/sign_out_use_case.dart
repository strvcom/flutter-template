import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/provider/current_user_model_state.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_use_case.g.dart';

@riverpod
Future<void> signOutUseCase(Ref ref) async {
  Flogger.d('[Authentication] Going to sign out current user');

  // Title: Try to sign out from Google - if any
  try {
    await GoogleSignIn.instance.disconnect();
  } on MissingPluginException catch (error) {
    Flogger.d('[Authentication] MissingPluginException $error');
  } on PlatformException catch (error) {
    Flogger.d('[Authentication] PlatformException $error');
  }

  // Title: Sign out from Firebase
  await FirebaseAuth.instance.signOut();

  // Title: Clear current user state
  await ref.read(currentUserModelStateProvider.notifier).updateCurrentUser(null);

  Flogger.d('[Authentication] Sign out complete');
}
