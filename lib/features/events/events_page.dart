import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_app_bar.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/features/events/events_page_content.dart';

@RoutePage()
class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.locale.featureHomepageTitle),
      body: const EventsPageContent(),
    );
  }
}
