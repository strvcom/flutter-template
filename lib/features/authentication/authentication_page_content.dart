import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_button/custom_button_primary.dart';
import 'package:flutter_app/common/extension/async_value.dart';
import 'package:flutter_app/features/authentication/authentication_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationPageContent extends ConsumerWidget {
  const AuthenticationPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authenticationStateProvider);

    return state.mapContentState(
      provider: authenticationStateProvider,
      data: (data) => _DataStateWidget(data: data),
    );
  }
}

class _DataStateWidget extends ConsumerWidget {
  const _DataStateWidget({required this.data});

  final AuthenticationState data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            CustomButtonPrimary(
              text: 'Mock Sign In',
              onPressed: () => ref.read(authenticationStateProvider.notifier).mockSignIn(),
            ),
            const SizedBox(height: 48),
            CustomButtonPrimary(
              text: 'Sign in Anonymously',
              onPressed: () => ref.read(authenticationStateProvider.notifier).signInAnonymously(),
            ),
            const SizedBox(height: 24),
            CustomButtonPrimary(
              text: 'Sign in with Google',
              isLoading: data.isGoogleSigningIn,
              onPressed: () => ref.read(authenticationStateProvider.notifier).signInWithGoogle(),
            ),
            const SizedBox(height: 8),
            CustomButtonPrimary(
              text: 'Sign in with Apple',
              isLoading: data.isAppleSigningIn,
              onPressed: () => ref.read(authenticationStateProvider.notifier).signInWithApple(),
            ),
          ],
        ),
      ),
    );
  }
}
