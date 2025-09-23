import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_authorization_token_use_case.g.dart';

@riverpod
Future<String?> getAuthorizationTokenUseCase(
  Ref ref, {
  bool forceRefresh = false,
}) async {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final token = await firebaseUser?.getIdToken(forceRefresh);

  Flogger.d('[Authorization] GET - Current Firebase Authorization Token: $token');

  return token;
}
