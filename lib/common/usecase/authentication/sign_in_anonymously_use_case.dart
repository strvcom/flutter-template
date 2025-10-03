import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/common/data/entity/user_entity.dart';
import 'package:flutter_app/common/usecase/authentication/sign_in_completion_use_case.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInAnonymouslyUseCase = FutureProvider.autoDispose<UserEntity>((ref) async {
  Flogger.d('[Authentication] Going to sign in user anonymously');

  await FirebaseAuth.instance.signInAnonymously();

  final user = await ref.read(signInCompletionUseCaseProvider.future);

  return user;
});
