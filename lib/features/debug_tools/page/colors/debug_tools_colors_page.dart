import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_app_bar.dart';
import 'package:flutter_app/features/debug_tools/page/colors/debug_tools_colors_page_content.dart';

class DebugToolsColorsPage extends StatelessWidget {
  const DebugToolsColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Colors'.toUpperCase(),
      ),
      body: const SafeArea(
        child: DebugToolsColorsPageContent(),
      ),
    );
  }
}
