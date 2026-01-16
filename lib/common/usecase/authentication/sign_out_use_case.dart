import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/provider/current_user_state.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_use_case.g.dart';

@riverpod
Future<void> signOutUseCase(Ref ref) async {
  Flogger.d('[Authentication] Going to sign out current user');

  // Title: Clear current user state
  await ref.read(currentUserStateProvider.notifier).updateCurrentUser(null);

  // Title: Try to sign out from Google - if any
  try {
    await GoogleSignIn.instance.disconnect();
  } on MissingPluginException catch (error) {
    Flogger.e('[Authentication] Sign Out MissingPluginException $error');
  } on PlatformException catch (error) {
    Flogger.e('[Authentication] Sign Out PlatformException $error');
  } on Exception catch (error) {
    Flogger.e('[Authentication] Sign Out Exception $error');
  }

  // Title: Sign out from Firebase
  await FirebaseAuth.instance.signOut();

  Flogger.d('[Authentication] Sign out complete');
}
