import 'package:flutter/material.dart';
import 'package:flutter_app/common/animation/shimmer_loading_animation.dart';
import 'package:flutter_app/common/component/custom_button/custom_button_primary.dart';
import 'package:flutter_app/common/component/custom_profile_avatar.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/extension/async_value.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/features/profile/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePageContent extends ConsumerWidget {
  const ProfilePageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileStateProvider);

    return state.mapContentState(
      provider: profileStateProvider,
      loading: (loading) => const _LoadingStateWidget(),
      data: (data) => _DataStateWidget(data: data),
    );
  }
}

class _LoadingStateWidget extends ConsumerWidget {
  const _LoadingStateWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: context.colorScheme.shimmerBackground,
              borderRadius: BorderRadius.circular(60),
            ),
          ).shimmerLoadingAnimation(context),
          const SizedBox(height: 12),
          CustomText.shimmerLoading(context: context, sampleText: 'John Doe', style: context.textTheme.headlineLarge),
          const Spacer(),
          CustomButtonPrimary(
            text: 'Sign out',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _DataStateWidget extends ConsumerWidget {
  const _DataStateWidget({required this.data});

  final ProfileState data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CustomProfileAvatar(imageUrl: data.imageUrl, size: 120),
          const SizedBox(height: 12),
          CustomText(text: data.displayName, style: context.textTheme.headlineLarge),
          const Spacer(),
          CustomButtonPrimary(
            text: 'Sign out',
            isLoading: data.isSigningOut,
            onPressed: () => ref.read(profileStateProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }
}
