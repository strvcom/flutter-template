import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_app_bar.dart';
import 'package:flutter_app/features/event_detail/event_detail_page_content.dart';

@RoutePage()
class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'EventDetail',
      ),
      body: SafeArea(
        child: EventDetailPageContent(),
      ),
    );
  }
}
