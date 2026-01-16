import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_anonymously_use_case.g.dart';

@riverpod
Future<void> signInAnonymouslyUseCase(Ref ref) async {
  Flogger.d('[Authentication] Going to sign in user anonymously');

  await FirebaseAuth.instance.signInAnonymously();
}
