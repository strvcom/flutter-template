import 'package:flutter_app/common/data/model/exception/custom_exception.dart';
import 'package:flutter_app/common/data/model/user_model.dart';
import 'package:flutter_app/common/usecase/authentication/sign_in_anonymously_use_case.dart';
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
    required bool isSigningIn,
  }) = _AuthenticationState;
}

@riverpod
class AuthenticationStateNotifier extends _$AuthenticationStateNotifier with AutoDisposeStateHandler {
  @override
  FutureOr<AuthenticationState> build() async {
    return const AuthenticationState(
      isSigningIn: false,
    );
  }

  Future<void> signInAnonymously() async {
    _signInWithProvider(signInAnonymouslyUseCaseProvider);
  }

  Future<void> signInWithGoogle() async {
    _signInWithProvider(signInWithGoogleUseCaseProvider);
  }

  Future<void> signInWithApple() async {
    _signInWithProvider(signInWithAppleUseCaseProvider);
  }

  Future<void> _signInWithProvider(AutoDisposeFutureProvider<UserModel> provider) async {
    setStateData(currentData?.copyWith(isSigningIn: true));

    try {
      await ref.read(provider.future);

      // Sign in success
      ref.read(authenticationEventNotifierProvider.notifier).send(const AuthenticationEvent.signedIn());
    } on Exception catch (error) {
      final customException = CustomException.fromErrorObject(error: error);
      if (customException case CustomExceptionSignInCancelled()) {
        Flogger.d('User cancelled the sign in process');
      } else {
        Flogger.e('Error while signing in: $customException');
      }
    }

    setStateData(currentData?.copyWith(isSigningIn: false));
  }
}
