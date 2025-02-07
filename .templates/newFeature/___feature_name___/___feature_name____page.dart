import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/common/component/custom_app_bar.dart';
import 'package:flutter_app/common/component/custom_snackbar/custom_snackbar_error.dart';
import 'package:flutter_app/features/___feature_name___/___feature_name____page_content.dart';
import 'package:flutter_app/features/___feature_name___/___feature_name____event.dart';

@RoutePage()
class ___FeatureName___Page extends ConsumerWidget {
  const ___FeatureName___Page({super.key});

  ref.listen(
      ___FeatureName___EventNotifierProvider,
      (_, next) => next?.when(
        error: (error) => CustomSnackbarError(
          context: context,
          message: error.getMessage(context: context),
        ).show(),
      ),
    );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
