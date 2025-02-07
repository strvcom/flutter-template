import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_app_bar.dart';
import 'package:flutter_app/features/___feature_name___/___feature_name____page_content.dart';

@RoutePage()
class ___FeatureName___Page extends StatelessWidget {
  const ___FeatureName___Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: '___FeatureName___',
      ),
      body: SafeArea(
        child: ___FeatureName___PageContent(),
      ),
    );
  }
}
