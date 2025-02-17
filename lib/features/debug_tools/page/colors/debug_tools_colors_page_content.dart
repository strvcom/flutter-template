import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/features/debug_tools/page/colors/model/debug_tools_color.dart';

class DebugToolsColorsPageContent extends StatelessWidget {
  const DebugToolsColorsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      children: [
        CustomText(text: 'Light mode', style: context.textTheme.headlineLarge),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            for (final color in DebugToolsColor.getColors(brightness: Brightness.light)) _createItem(color: color, context: context),
            const SizedBox(height: 40),
          ],
        ),
        const SizedBox(height: 40),
        CustomText(text: 'Dark mode', style: context.textTheme.headlineLarge),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            for (final color in DebugToolsColor.getColors(brightness: Brightness.dark)) _createItem(color: color, context: context),
          ],
        ),
      ],
    );
  }

  Widget _createItem({
    required DebugToolsColor color,
    required BuildContext context,
  }) {
    final textColor = color.color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Center(
          child: CustomText(
            text: color.colorName,
            style: context.textTheme.labelSmall,
            color: textColor,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
