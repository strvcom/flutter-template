import 'package:flutter/material.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BottomSheetContainerWidget extends StatelessWidget {
  const BottomSheetContainerWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: kDefaultBarTopRadius, topRight: kDefaultBarTopRadius),
        ),
        color: context.colorScheme.surface,
        elevation: 2,
        child: Stack(
          children: [
            SafeArea(
              top: false,
              bottom: false,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                controller: ModalScrollController.of(context),
                child: Padding(
                  padding: EdgeInsets.only(top: kToolbarHeight + 8, bottom: MediaQuery.paddingOf(context).bottom),
                  child: child,
                ),
              ),
            ),
            const Positioned(left: 0, right: 0, child: Center(child: _CustomBottomSheetHandleWidget())),
          ],
        ),
      ),
    );
  }
}

class _CustomBottomSheetHandleWidget extends StatelessWidget {
  const _CustomBottomSheetHandleWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Container(
        width: 48,
        height: 4,
        decoration: BoxDecoration(
          color: context.colorScheme.secondary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
