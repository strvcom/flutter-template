import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_app_bar.dart';
import 'package:flutter_app/features/authentication/authentication_page_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class AuthenticationPage extends ConsumerWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
