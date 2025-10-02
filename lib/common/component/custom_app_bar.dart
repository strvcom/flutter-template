import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/custom_system_bars_theme.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/common/provider/theme_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.toolbarHeight,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.forceElevated,
    this.brightness,
    this.backgroundColor,
  });

  final String? title;
  final Widget? titleWidget;
  final double? toolbarHeight;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final bool? forceElevated;
  final Brightness? brightness;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeBrightness = brightness ?? ref.read(themeModeProvider.notifier).brightness;
    return AppBar(
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: false,
      title: titleWidget ?? (title != null ? CustomText(text: title!, style: context.textTheme.titleMedium) : null),
      systemOverlayStyle: CustomSystemBarsTheme.getSystemBarsTheme(brightness: themeModeBrightness),
      backgroundColor: backgroundColor ?? context.colorScheme.surface,
      surfaceTintColor: backgroundColor ?? context.colorScheme.surface, // Needs to be the same as backgroundColor
      foregroundColor: context.colorScheme.onSurface,
      titleTextStyle: context.textTheme.titleLarge,
      shadowColor: context.colorScheme.shadow,
      scrolledUnderElevation: 4,
      elevation: (forceElevated ?? false) ? 4 : 0,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
