import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/assets.gen.dart';
import 'package:flutter_app/common/component/custom_progress_indicator.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    required this.url,
    required this.width,
    required this.height,
    super.key,
    this.fit,
    this.shape,
    this.border,
    this.borderRadius,
  });

  const CustomNetworkImage.square({
    required this.url,
    required double? size,
    super.key,
    this.fit,
    this.shape,
    this.border,
    this.borderRadius,
  }) : width = size,
       height = size;

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BoxShape? shape;
  final Border? border;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      shape: shape,
      border: border,
      borderRadius: borderRadius,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return const Center(child: CustomProgressIndicator());
          case LoadState.completed:
            return state.completedWidget;
          case LoadState.failed:
            return Assets.svg.icErrorCircle.svg(width: width, height: height);
        }
      },
    );
  }
}
