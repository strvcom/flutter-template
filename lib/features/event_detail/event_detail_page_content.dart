import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class EventDetailPageContent extends StatelessWidget {
  const EventDetailPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomText(text: 'event_detail', style: context.textTheme.titleMedium),
    );
  }
}
