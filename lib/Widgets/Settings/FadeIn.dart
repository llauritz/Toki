import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum _AniProps { opacity, offset }

class FadeIn extends StatelessWidget {
  final int delay;
  final Widget fadeChild;

  FadeIn({required this.delay, required this.fadeChild});

  @override
  Widget build(BuildContext context) {
    var _tween = MultiTween<_AniProps>()..add(_AniProps.opacity, Tween(begin: 0.0, end: 1.0))..add(_AniProps.offset, Tween(begin: 70.0, end: 0.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: Duration(milliseconds: delay),
      tween: _tween,
      duration: const Duration(milliseconds: 450),
      curve: Curves.ease,
      builder: (context, child, value) {
        return Opacity(
            opacity: value.get(_AniProps.opacity), child: Transform.translate(offset: Offset(0, value.get(_AniProps.offset)), child: fadeChild));
      },
    );
  }
}
