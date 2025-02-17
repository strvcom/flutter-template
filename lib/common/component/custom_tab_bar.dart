import 'package:flutter/material.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    this.tabController,
    required this.tabs,
    this.onTap,
  });

  final TabController? tabController;
  final List<Tab> tabs;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabAlignment: TabAlignment.start,
      onTap: onTap,
      controller: tabController,
      dividerColor: Colors.transparent,
      indicatorColor: context.colorScheme.secondary,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      labelPadding: const EdgeInsets.symmetric(horizontal: 10),
      labelStyle: context.textTheme.bodyMedium,
      labelColor: context.colorScheme.secondary,
      unselectedLabelStyle: context.textTheme.bodyMedium,
      unselectedLabelColor: context.colorScheme.secondary.withValues(alpha: 0.5),
      isScrollable: true,
      overlayColor: WidgetStatePropertyAll(context.colorScheme.onSecondary.withValues(alpha: 0.1)),
      splashBorderRadius: BorderRadius.circular(16),
      tabs: tabs,
    );
  }
}
