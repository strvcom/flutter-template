import 'package:flutter/material.dart';
import 'package:flutter_app/common/extension/async_value.dart';
import 'package:flutter_app/features/___feature_name___/___feature_name____state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ___FeatureName___PageContent extends ConsumerWidget {
  const ___FeatureName___PageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(___featureName___StateNotifierProvider);

    return state.mapContentState(
      provider: ___featureName___StateNotifierProvider,
      isEmpty: (data) => true,
      data: (data) => _DataStateWidget(data: data),
    );
  }
}

class _DataStateWidget extends ConsumerWidget {
  const _DataStateWidget({required this.data});

  final ___FeatureName___State data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Text('sample'),
    );
  }
}
