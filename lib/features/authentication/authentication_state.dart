import 'package:flutter_app/common/data/entity/exception/custom_exception.dart';
import 'package:flutter_app/common/provider/current_user_state.dart';
import 'package:flutter_app/common/usecase/authentication/sign_in_anonymously_use_case.dart';
import 'package:flutter_app/common/usecase/authentication/sign_in_completion_use_case.dart';
import 'package:flutter_app/common/usecase/authentication/sign_in_with_apple_use_case.dart';
import 'package:flutter_app/common/usecase/authentication/sign_in_with_google_use_case.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_app/core/riverpod/state_handler.dart';
import 'package:flutter_app/features/authentication/authentication_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_state.freezed.dart';
part 'authentication_state.g.dart';

@freezed
abstract class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    required bool isGoogleSigningIn,
    required bool isAppleSigningIn,
  }) = _AuthenticationState;
}

@riverpod
class AuthenticationStateNotifier extends _$AuthenticationStateNotifier with AutoDisposeStateHandler {
  @override
  FutureOr<AuthenticationState> build() async {
    return const AuthenticationState(
      isGoogleSigningIn: false,
      isAppleSigningIn: false,
    );
  }

  Future<void> signInAnonymously() async {
    final provider = ref.read(signInAnonymouslyUseCaseProvider.future);
    await _signInCompletion(provider);
  }

  Future<void> signInWithGoogle() async {
    setStateData(currentData?.copyWith(isGoogleSigningIn: true));
    final provider = ref.read(signInWithGoogleUseCaseProvider.future);
    await _signInCompletion(provider);
    setStateData(currentData?.copyWith(isGoogleSigningIn: false));
  }

  Future<void> signInWithApple() async {
    setStateData(currentData?.copyWith(isAppleSigningIn: true));
    final provider = ref.read(signInWithAppleUseCaseProvider.future);
    await _signInCompletion(provider);
    setStateData(currentData?.copyWith(isAppleSigningIn: false));
  }

  Future<void> _signInCompletion(Future<void> provider) async {
    try {
      await provider;

      // Sign in completion on BE
      final user = await ref.read(signInCompletionUseCaseProvider.future);

      // Update current user
      await ref.read(currentUserStateProvider.notifier).updateCurrentUser(user);

      // Sign in success
      ref.read(authenticationEventNotifierProvider.notifier).send(const AuthenticationEvent.signedIn());
    } on Exception catch (error) {
      final customException = CustomException.fromErrorObject(error: error);
      customException.maybeWhen(
        signInCancelled: () {
          Flogger.d('[Authentication] User cancelled the sign in process');
        },
        orElse: () {
          Flogger.e('[Authentication] Error while signing in: $customException');
          ref.read(authenticationEventNotifierProvider.notifier).send(AuthenticationEvent.error(customException));
        },
      );
    }
  }
}
