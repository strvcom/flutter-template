import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_router.dart';
import 'package:flutter_app/common/animation/custom_fade_slide_animation.dart';
import 'package:flutter_app/common/component/custom_button/custom_button_primary.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomFadeSlideAnimation(
                delay: const Duration(milliseconds: 300),
                child: CustomText(
                  key: const Key('home_title'), // Used for Integration testing
                  text: 'Home',
                  style: context.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              CustomFadeSlideAnimation(
                delay: const Duration(milliseconds: 600),
                child: CustomButtonPrimary(
                  onPressed: () => context.pushRoute(const DebugToolsRoute()),
                  text: context.locale.featureHomepageOpenDebugTools,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
