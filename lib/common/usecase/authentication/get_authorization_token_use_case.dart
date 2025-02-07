import 'package:flutter_app/common/usecase/authentication/get_firebase_user_use_case.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_authorization_token_use_case.g.dart';

@riverpod
Future<String?> getAuthorizationTokenUseCase(
  Ref ref, {
  forceRefresh = false,
}) async {
  final firebaseUser = await ref.read(getFirebaseUserUseCaseProvider.future);
  final token = await firebaseUser?.getIdToken(forceRefresh);

  Flogger.d('[Authorization] GET - Current Firebase Authorization Token: $token');

  return token;
}
