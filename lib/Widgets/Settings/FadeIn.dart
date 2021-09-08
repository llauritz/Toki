import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum _AniProps { opacity, offset }

class FadeIn extends StatelessWidget {
  const FadeIn({
    required child,
    this.delay = 0,
    this.curve = Curves.ease,
    this.duration = 400
  }) : fadeChild = child;

  final int delay;
  final int duration;
  final Curve curve;
  final Widget fadeChild;

  @override
  Widget build(BuildContext context) {
    var _tween = MultiTween<_AniProps>()..add(_AniProps.opacity, Tween(begin: 0.0, end: 1.0))..add(_AniProps.offset, Tween(begin: 70.0, end: 0.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: Duration(milliseconds: delay),
      tween: _tween,
      duration: const Duration(milliseconds: 700),
      curve: curve,
      builder: (context, child, value) {
        return AnimatedOpacity(
            duration: Duration.zero,
            opacity: value.get(_AniProps.opacity),
            child: Transform.translate(offset: Offset(0, value.get(_AniProps.offset)), child: fadeChild));
      },
    );
  }
}
