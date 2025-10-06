import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_router.dart';
import 'package:flutter_app/common/component/custom_app_bar.dart';
import 'package:flutter_app/features/profile/profile_event.dart';
import 'package:flutter_app/features/profile/profile_page_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      profileEventNotifierProvider,
      (_, next) => switch (next) {
        ProfileEventSignedOut() => context.router.replaceAll([const LandingRoute()]),
        _ => () {},
      },
    );

    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
      ),
      body: SafeArea(
        child: ProfilePageContent(),
      ),
    );
  }
}
