import 'package:flutter/material.dart';

class ActionIcon extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const ActionIcon({required this.child, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ));
}
