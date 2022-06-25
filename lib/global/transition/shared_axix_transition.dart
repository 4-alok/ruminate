import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SharedAxisTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
          PageRoute<T> route,
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) =>
      SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.scaled,
        child: child,
      );
}
