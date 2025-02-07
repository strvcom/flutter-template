import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_router.dart';
import 'package:flutter_app/common/component/custom_button/custom_button_primary.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class EventsPageContent extends StatelessWidget {
  const EventsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(text: 'Events', style: context.textTheme.titleMedium),
            const SizedBox(height: 16),
            CustomButtonPrimary(
              text: 'Event Detail',
              onPressed: () => context.pushRoute(const EventDetailRoute()),
            ),
          ],
        ),
      ),
    );
  }
}
