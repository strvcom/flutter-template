import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_router.dart';
import 'package:flutter_app/common/component/custom_app_bar.dart';
import 'package:flutter_app/features/authentication/authentication_event.dart';
import 'package:flutter_app/features/authentication/authentication_page_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class AuthenticationPage extends ConsumerWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authenticationEventNotifierProvider,
      (_, next) {
        next?.whenOrNull(
          signedIn: () => context.router.replaceAll([const LandingRoute()]),
        );
      },
    );

    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Authentication',
      ),
      body: SafeArea(
        child: AuthenticationPageContent(),
      ),
    );
  }
}
