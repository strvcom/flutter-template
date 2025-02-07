import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/assets.gen.dart';
import 'package:flutter_app/common/component/custom_app_bar.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/composition/responsive_widget.dart';
import 'package:flutter_app/common/extension/async_value.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/features/debug_tools/debug_tools_page_state.dart';
import 'package:flutter_app/features/debug_tools/page/actions/debug_tools_actions_page_content.dart';
import 'package:flutter_app/features/debug_tools/page/colors/debug_tools_colors_page_content.dart';
import 'package:flutter_app/features/debug_tools/page/popups/debug_tools_popups_page_content.dart';
import 'package:flutter_app/features/debug_tools/page/text_styles/debug_tools_text_styles_page_content.dart';
import 'package:flutter_app/features/debug_tools/page/widgets/debug_tools_widgets_page_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This should act as a sample code of how to properly implement adaptive layout.
/// The idea of this screen is to have two layout available.
/// To make it as complex as possible, on a small screen we will show navigation buttons that will open separate screens,
/// On medium screen we will display navigation on the left, and the content on the right of it.
@RoutePage()
class DebugToolsPage extends ConsumerWidget {
  const DebugToolsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateProvider = ref.watch(debugToolsPageStateNotifierProvider);

    return stateProvider.mapState(
      provider: debugToolsPageStateNotifierProvider,
      data: (data) => Scaffold(
        appBar: const CustomAppBar(
          title: 'Debug tools',
        ),
        body: PopScope(
          canPop: data.selectedAction == null || !ResponsiveWidget.isSmallScreen(context),
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              ref.read(debugToolsPageStateNotifierProvider.notifier).setAction(null);
            }
          },
          child: SafeArea(
            child: ResponsiveWidget(
              small: () => (data.selectedAction != null)
                  ? _SecondaryContentWidget(selectedAction: data.selectedAction)
                  : const DebugToolsActionsPageContent(),
              medium: () => Row(
                children: [
                  const SizedBox(width: 440, child: DebugToolsActionsPageContent()),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Container(width: 1, color: context.colorScheme.divider),
                  ),
                  Expanded(child: _SecondaryContentWidget(selectedAction: data.selectedAction)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryContentWidget extends StatelessWidget {
  const _SecondaryContentWidget({required this.selectedAction});

  final DebugToolsSampleType? selectedAction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        switch (selectedAction) {
          case DebugToolsSampleType.widgets:
            return const DebugToolsWidgetsPageContent();
          case DebugToolsSampleType.popups:
            return const DebugToolsPopupsPageContent();
          case DebugToolsSampleType.colors:
            return const DebugToolsColorsPageContent();
          case DebugToolsSampleType.textStyles:
            return const DebugToolsTextStylesPageContent();
          default:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.png.flutterIcon.image(width: 64),
                  const SizedBox(height: 20),
                  CustomText(text: 'Please select a sample.', style: context.textTheme.bodyMedium),
                ],
              ),
            );
        }
      },
    );
  }
}
