import 'package:flutter/material.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/features/debug_tools/page/text_styles/model/debug_tools_text_style.dart';

class DebugToolsTextStylesPageContent extends StatelessWidget {
  const DebugToolsTextStylesPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = context.theme.brightness;
    final textStyles = DebugToolsTextStyle.getTextStyles(context: context, brightness: brightness);

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: textStyles.length,
      itemBuilder: (context, index) => Text(
        '${textStyles[index].name}\nFont: ${textStyles[index].textStyle?.fontFamily}\nSize: ${textStyles[index].textStyle?.fontSize}\nWeight: ${textStyles[index].textStyle?.fontWeight?.value}',
        style: textStyles[index].textStyle,
        textAlign: TextAlign.left,
      ),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Container(
          height: 1,
          color: context.colorScheme.divider,
        ),
      ),
    );
  }
}
