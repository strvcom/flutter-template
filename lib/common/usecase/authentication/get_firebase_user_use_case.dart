import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_firebase_user_use_case.g.dart';

@riverpod
Future<User?> getFirebaseUserUseCase(Ref ref) async {
  final user = FirebaseAuth.instance.currentUser;

  Flogger.d('[Authentication] GET - Current Firebase user: $user');

  return user;
}
