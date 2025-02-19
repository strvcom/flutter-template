import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/common/component/custom_button/custom_button_primary.dart';
import 'package:flutter_app/common/component/custom_switch.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_app/features/debug_tools/debug_tools_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DebugToolsActionsPageContent extends ConsumerStatefulWidget {
  const DebugToolsActionsPageContent({super.key});

  @override
  ConsumerState<DebugToolsActionsPageContent> createState() => _DebugToolsActionsPageContentState();
}

class _DebugToolsActionsPageContentState extends ConsumerState<DebugToolsActionsPageContent> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        CustomText(text: 'Actions', style: context.textTheme.headlineLarge),
        const SizedBox(height: 20),
        CustomButtonPrimary(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Theme(
                  data: ThemeData(colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)),
                  child: TalkerScreen(
                    talker: Flogger.talker,
                    theme: TalkerScreenTheme(
                      logColors: {TalkerLogType.debug: Colors.green},
                    ),
                  ),
                ),
              ),
            );
          },
          text: 'Console Logs',
        ),
        const SizedBox(height: 20),
        ...getToolsSectionList(context, ref),
        const SizedBox(height: 20),
        ...getSamplesSectionList(context, ref),
      ],
    );
  }

  List<Widget> getToolsSectionList(BuildContext context, WidgetRef ref) {
    return [
      CustomText(text: 'Tools', style: context.textTheme.headlineLarge),
      const SizedBox(height: 20),
      CustomSwitch(
        title: 'Show Layout Bounds',
        value: debugPaintSizeEnabled,
        dense: true,
        onChanged: (value) => setState(() => debugPaintSizeEnabled = !debugPaintSizeEnabled),
      ),
      CustomSwitch(
        title: 'Show Baselines',
        value: debugPaintBaselinesEnabled,
        dense: true,
        onChanged: (value) => setState(() => debugPaintBaselinesEnabled = !debugPaintBaselinesEnabled),
      ),
      CustomSwitch(
        title: 'Show Repaint',
        value: debugRepaintRainbowEnabled,
        dense: true,
        onChanged: (value) => setState(() => debugRepaintRainbowEnabled = !debugRepaintRainbowEnabled),
      ),
      CustomSwitch(
        title: 'Time Dilation',
        value: timeDilation != 1,
        dense: true,
        onChanged: (value) => setState(() => timeDilation = (timeDilation == 6) ? 1 : 6),
      ),
    ];
  }

  List<Widget> getSamplesSectionList(BuildContext context, WidgetRef ref) {
    return [
      CustomText(text: 'Samples', style: context.textTheme.headlineLarge),
      const SizedBox(height: 20),
      CustomButtonPrimary(
        text: 'Widgets sample',
        onPressed: () => ref.read(debugToolsPageStateNotifierProvider.notifier).setAction(DebugToolsSampleType.widgets),
      ),
      const SizedBox(height: 16),
      CustomButtonPrimary(
        text: 'Popups sample',
        onPressed: () => ref.read(debugToolsPageStateNotifierProvider.notifier).setAction(DebugToolsSampleType.popups),
      ),
      const SizedBox(height: 16),
      CustomButtonPrimary(
        text: 'Colors sample',
        onPressed: () => ref.read(debugToolsPageStateNotifierProvider.notifier).setAction(DebugToolsSampleType.colors),
      ),
      const SizedBox(height: 16),
      CustomButtonPrimary(
        text: 'Text Styles sample',
        onPressed: () => ref.read(debugToolsPageStateNotifierProvider.notifier).setAction(DebugToolsSampleType.textStyles),
      ),
    ];
  }
}
