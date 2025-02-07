import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_app_bar.dart';
import 'package:flutter_app/features/debug_tools/page/text_styles/debug_tools_text_styles_page_content.dart';

class DebugToolsTextStylesPage extends StatelessWidget {
  const DebugToolsTextStylesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Text styles'.toUpperCase(),
      ),
      body: const SafeArea(
        child: DebugToolsTextStylesPageContent(),
      ),
    );
  }
}
