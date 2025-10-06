import 'package:flutter/material.dart';

/// [CustomFadeSlideAnimation] is build using [FadeTransition] and [SlideTransition]

/// Fade and Slide animation wrapper widget
/// Just wrap the child with this widget and widget will be animated
/// [child] : the widget to be animated
/// [fadeDuration] : duration of animation of fade (default: Duration(milliseconds: 1000))
/// [slideDuration] : duration of animation of slide (default: Duration(milliseconds: 500))
/// [fadeCurve] : curve of the fade animation (default: [Curves.decelerate])
/// [slideCurve] : curve of the scale animation (default: [Curves.decelerate])
/// [delay] : delay before the animation start (default: Duration(milliseconds: 0))
/// [textDirection] : direction of the text for slide animation (default: [TextDirection.ltr])
class CustomFadeSlideAnimation extends StatefulWidget {
  const CustomFadeSlideAnimation({
    required this.child,
    super.key,
    this.beginOffset = const Offset(0, 0.5),
    this.endOffset = Offset.zero,
    this.fadeDuration = const Duration(milliseconds: 1000),
    this.slideDuration = const Duration(milliseconds: 500),
    this.fadeCurve = Curves.decelerate,
    this.slideCurve = Curves.decelerate,
    this.delay = Duration.zero,
    this.textDirection = TextDirection.ltr,
  });

  final Widget child;
  final Offset beginOffset;
  final Offset endOffset;
  final Duration fadeDuration;
  final Duration slideDuration;
  final Curve fadeCurve;
  final Curve slideCurve;
  final Duration delay;
  final TextDirection textDirection;

  @override
  CustomFadeSlideAnimationState createState() => CustomFadeSlideAnimationState();
}

/// [TickerProviderStateMixin] is used because two animation controllers are being used for making [CustomFadeSlideAnimation].
class CustomFadeSlideAnimationState extends State<CustomFadeSlideAnimation> with TickerProviderStateMixin {
  late CurvedAnimation _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late AnimationController? _fadeController;
  late AnimationController? _slideController;

  /// Controllers are initialized in [initState] with the values defined or received as parameters in the widget
  @override
  void initState() {
    super.initState();
    // Setup animation controllers
    _fadeController = AnimationController(vsync: this, duration: widget.fadeDuration);
    _slideController = AnimationController(vsync: this, duration: widget.slideDuration);

    // Create animations
    _fadeAnimation = CurvedAnimation(parent: _fadeController!, curve: widget.fadeCurve);
    _slideAnimation = Tween<Offset>(begin: widget.beginOffset, end: widget.endOffset).animate(
      CurvedAnimation(parent: _slideController!, curve: widget.slideCurve),
    );

    // Start animation after the specified delay
    Future<void>.delayed(widget.delay).then((value) => {_fadeController?.forward(), _slideController?.forward()});
  }

  /// Both the animation controllers are being disposed for safety
  @override
  void dispose() {
    _fadeController?.dispose();
    _slideController?.dispose();
    _fadeController = null;
    _slideController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        textDirection: widget.textDirection,
        child: widget.child,
      ),
    );
  }
}
