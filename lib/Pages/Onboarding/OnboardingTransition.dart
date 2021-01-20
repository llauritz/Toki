import 'package:flutter/material.dart';

Route onboardingTransitionRoute(Widget _target) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => _target,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {

      double begin = 0.0;
      double end = 1;
      Curve curve = Curves.easeOutQuint;

      Tween<double> tween = Tween(begin: begin, end: end);
      CurvedAnimation curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SizeTransition(
        sizeFactor: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}