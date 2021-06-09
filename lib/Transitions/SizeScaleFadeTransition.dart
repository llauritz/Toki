import 'package:flutter/material.dart';

class SizeScaleFadeTransition extends StatelessWidget {
  const SizeScaleFadeTransition({
    required this.animation,
    required this.child,
    Key? key,
  }) : super(key: key);

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: -1.0,
      sizeFactor:
          CurvedAnimation(parent: animation, curve: Curves.easeInOutQuart),
      child: ScaleTransition(
        alignment: Alignment.topCenter,
        scale: CurvedAnimation(parent: animation, curve: Curves.easeOutQuart),
        child: FadeTransition(
          opacity: CurvedAnimation(
              parent: CurvedAnimation(curve: Curves.ease, parent: animation),
              curve: Interval(0.8, 1)),
          child: child,
        ),
      ),
    );
  }
}
