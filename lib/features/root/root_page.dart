import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_router.dart';
import 'package:flutter_app/common/component/custom_bottom_app_bar.dart';

@RoutePage()
class RootPage extends StatelessWidget {
  const RootPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        HomeRoute(),
        EventsRoute(),
        ProfileRoute(),
      ],
      homeIndex: 0,
      bottomNavigationBuilder: (_, tabsRouter) {
        return CustomBottomAppBar(
          selectedIndex: tabsRouter.activeIndex,
          items: [
            CustomBottomAppBarItem(
              label: 'Home',
              icon: Icons.home,
              onSelectListener: () => tabsRouter.setActiveIndex(0),
            ),
            CustomBottomAppBarItem(
              label: 'Events',
              icon: Icons.event,
              onSelectListener: () => tabsRouter.setActiveIndex(1),
            ),
            CustomBottomAppBarItem(
              label: 'Profile',
              icon: Icons.person,
              onSelectListener: () => tabsRouter.setActiveIndex(2),
            ),
          ],
        );
      },
    );
  }
}
