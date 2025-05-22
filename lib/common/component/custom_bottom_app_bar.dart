import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({
    required this.selectedIndex,
    required this.items,
    super.key,
  });

  final int selectedIndex;
  final List<CustomBottomAppBarItem> items;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      surfaceTintColor: Colors.transparent,
      color: context.colorScheme.surface,
      elevation: 8,
      height: 64,
      shadowColor: Colors.black,
      padding: EdgeInsets.zero,
      child: Row(
        children: items.mapIndexed((index, item) => _BottomAppBarButton(item: item, isSelected: index == selectedIndex)).toList(),
      ),
    );
  }
}

class CustomBottomAppBarItem {
  CustomBottomAppBarItem({
    required this.label,
    required this.icon,
    required this.onSelectListener,
  });

  String label;
  IconData icon;
  VoidCallback onSelectListener;
}

class _BottomAppBarButton extends StatelessWidget {
  const _BottomAppBarButton({
    required this.item,
    required this.isSelected,
  });

  final CustomBottomAppBarItem item;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final selectedColor = context.colorScheme.primary;
    final unSelectedColor = context.colorScheme.onSurface.withValues(alpha: 0.4);

    return Expanded(
      child: InkWell(
        onTap: item.onSelectListener,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: isSelected ? 26 : 24,
              color: isSelected ? selectedColor : unSelectedColor,
            ),
            const SizedBox(height: 2),
            CustomText(
              text: item.label,
              style: context.textTheme.labelMedium,
              color: isSelected ? selectedColor : unSelectedColor,
            ),
          ],
        ),
      ),
    );
  }
}
