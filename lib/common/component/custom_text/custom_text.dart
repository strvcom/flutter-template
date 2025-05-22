import 'package:flutter/material.dart';
import 'package:flutter_app/common/animation/shimmer_loading_animation.dart';
import 'package:flutter_app/common/extension/build_context.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    required this.text,
    required this.style,
    super.key,
    this.color,
    this.padding = EdgeInsets.zero,
    this.textAlign = TextAlign.start,
    this.maxLines,
  });

  final String text;
  final TextStyle style;
  final Color? color;
  final EdgeInsets padding;
  final TextAlign textAlign;
  final int? maxLines;

  static Widget shimmerLoading({
    required BuildContext context,
    required TextStyle style,
    required String sampleText,
    EdgeInsets padding = EdgeInsets.zero,
    TextAlign textAlign = TextAlign.start,
    int? maxLines,
  }) {
    return Padding(
      padding: padding,
      child: Stack(
        children: [
          // Title: Shimmering Container
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: context.colorScheme.shimmerBackground,
                borderRadius: BorderRadius.circular(4),
              ),
            ).shimmerLoadingAnimation(context),
          ),
          // Title: Sample Text widget
          Text(
            sampleText,
            maxLines: maxLines,
            overflow: maxLines == null ? null : TextOverflow.ellipsis,
            style: style.copyWith(color: Colors.transparent),
            textAlign: textAlign,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
        style: style.copyWith(color: color ?? style.color),
        textAlign: textAlign,
      ),
    );
  }
}
