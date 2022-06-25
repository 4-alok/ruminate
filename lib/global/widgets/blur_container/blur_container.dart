import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

class BlurContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final double elevation;
  final double blur;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderRadius borderRadius;

  const BlurContainer({
    Key? key,
    required this.child,
    this.height,
    this.width,
    this.blur = 5,
    this.elevation = 0,
    this.padding = const EdgeInsets.all(0),
    this.color = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            height: height,
            width: width,
            padding: padding,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[200]!.withOpacity(0.1)
                : color,
            child: child,
          ),
        ),
      );
}
