import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_router.dart';
import 'package:flutter_app/app/setup/app_platform.dart';
import 'package:flutter_app/common/provider/current_user_model_state.dart';
import 'package:flutter_app/common/provider/firebase_remote_config_service.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_app/features/landing/force_update_page_content.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Landing page is a great place to do a few stuff before navigating into the app
///
/// These are the stuff that should be probably handled there:
/// - Check for force update - Not letting users into the app, preventing further data loading.
/// - Check if there is a user signed in - Authentication-based navigation
/// - Deeplink handling - Handle deeplink and navigate to the correct screen.
@RoutePage()
class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  bool _forceUpdate = false;

  @override
  void initState() {
    super.initState();

    // We need to make sure that the Widget was build before using ref.
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleLandingPageNavigation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_forceUpdate == true) ? const ForceUpdatePageContent() : const SizedBox(),
    );
  }

  Future<void> _handleLandingPageNavigation() async {
    final forceUpdateRequired = await _handleForceUpdate();
    if (forceUpdateRequired) return;

    final currentUser = await ref.read(currentUserModelStateProvider.future);

    if (mounted) {
      FlutterNativeSplash.remove();

      if (currentUser == null) {
        Flogger.d('[LandingPage] Redirecting to Authentication page');
        context.replaceRoute(const AuthenticationRoute());
      } else {
        Flogger.d('[LandingPage] Redirecting to Home page');
        context.replaceRoute(const RootRoute());
      }
    }
  }

  Future<bool> _handleForceUpdate() async {
    if (AppPlatform.isMobile && Firebase.apps.isNotEmpty) {
      final firebaseRemoteConfigService = await ref.read(firebaseRemoteConfigServiceProvider.future);
      final minBuildNumber = firebaseRemoteConfigService.getMinSupportedBuildNumber();
      final packageInfo = await PackageInfo.fromPlatform();

      if (minBuildNumber > int.parse(packageInfo.buildNumber)) {
        setState(() {
          _forceUpdate = true;
        });
        return true;
      }
    }

    return false;
  }
}
