import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_router.dart';
import 'package:flutter_app/common/component/custom_button/custom_button_primary.dart';
import 'package:flutter_app/common/extension/async_value.dart';
import 'package:flutter_app/common/usecase/authentication/sign_in_completion_use_case.dart';
import 'package:flutter_app/features/authentication/authentication_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationPageContent extends ConsumerWidget {
  const AuthenticationPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authenticationStateNotifierProvider);

    return state.mapContentState(
      provider: authenticationStateNotifierProvider,
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
                isLoading: data.isSigningIn,
                onPressed: () async {
                  await ref.read(signInCompletionUseCaseProvider.future);
                  if (context.mounted) context.router.replaceAll([const LandingRoute()]);
                }),
            const SizedBox(height: 48),
            CustomButtonPrimary(
              text: 'Sign in Anonymously',
              isLoading: data.isSigningIn,
              onPressed: () => ref.read(authenticationStateNotifierProvider.notifier).signInAnonymously(),
            ),
            const SizedBox(height: 24),
            CustomButtonPrimary(
              text: 'Sign in with Google',
              isLoading: data.isSigningIn,
              onPressed: () => ref.read(authenticationStateNotifierProvider.notifier).signInWithGoogle(),
            ),
            const SizedBox(height: 8),
            CustomButtonPrimary(
              text: 'Sign in with Apple',
              isLoading: data.isSigningIn,
              onPressed: () => ref.read(authenticationStateNotifierProvider.notifier).signInWithApple(),
            ),
          ],
        ),
      ),
    );
  }
}
