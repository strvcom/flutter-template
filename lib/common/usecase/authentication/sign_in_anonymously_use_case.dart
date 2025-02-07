import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/common/data/model/user_model.dart';
import 'package:flutter_app/common/usecase/authentication/sign_in_completion_use_case.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_anonymously_use_case.g.dart';

@riverpod
Future<UserModel> signInAnonymouslyUseCase(Ref ref) async {
  Flogger.d('[Authentication] Going to sign in user anonymously');

  await FirebaseAuth.instance.signInAnonymously();

  final user = await ref.read(signInCompletionUseCaseProvider.future);

  return user;
}
