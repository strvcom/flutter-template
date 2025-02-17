import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/assets.gen.dart';
import 'package:flutter_app/common/component/custom_ink_well/custom_ink_well_circular.dart';
import 'package:flutter_app/common/component/custom_progress_indicator.dart';

class CustomClickableProfileAvatar extends StatelessWidget {
  const CustomClickableProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.size,
    required this.onClick,
    this.onLongClick,
  });

  final String imageUrl;
  final double size;
  final VoidCallback onClick;
  final VoidCallback? onLongClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CustomInkWellCircular(
        onClick: onClick,
        onLongClick: onLongClick,
        child: CustomProfileAvatar(
          imageUrl: imageUrl,
          size: size,
        ),
      ),
    );
  }
}

class CustomProfileAvatar extends StatelessWidget {
  const CustomProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.size,
  });

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: ExtendedImage.network(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          cache: true,
          loadStateChanged: (state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return const Center(child: CustomProgressIndicator());
              case LoadState.completed:
                return state.completedWidget;
              case LoadState.failed:
                return Assets.svg.icAvatarDark.svg(width: size, height: size);
            }
          },
        ),
      ),
    );
  }
}
