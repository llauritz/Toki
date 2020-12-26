import 'dart:ui';

import 'package:flutter/material.dart';

class FrostTransition extends AnimatedWidget {
  final Widget child;
  final Animation<double> animation;

  FrostTransition({this.animation, this.child}) : super(listenable: animation);

  @override
  Widget build(BuildContext context) => new BackdropFilter(
    filter: ImageFilter.blur(sigmaX: animation.value, sigmaY: animation.value),
    child: Container(
      child: child,
    ),
  );
}

class HeroDialogRouteBlur<T> extends PageRoute<T> {
  HeroDialogRouteBlur({ this.builder }) : super();

  static const double frostAnimationStartValue = 0.0;
  static const double frostAnimationEndValue = 5.0;
  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black38;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FrostTransition(
      animation: new Tween<double>(
          begin: frostAnimationStartValue,
          end: frostAnimationEndValue,
        ).animate(animation),
      child: new FadeTransition(
        opacity: new CurvedAnimation(
              parent: animation,
              curve: Curves.linear
          ),
        child: child,
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  String get barrierLabel => "label";

}