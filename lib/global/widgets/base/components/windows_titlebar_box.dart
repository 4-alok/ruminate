import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../app_drawer/window_button.dart';

class WindowsTitlebarBox extends StatelessWidget {
  final Widget? secondaryToolbarWidget;
  final String? title;
  final List<Widget> actions;
  const WindowsTitlebarBox(
      {this.title,
      required this.actions,
      required this.secondaryToolbarWidget,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).scaffoldBackgroundColor.withOpacity(.95),
              ]),
        ),
        height: kToolbarHeight * 2,
        child: Stack(
          children: [
            Column(
              children: [
                toolbar(context),
                secondaryToobar,
              ],
            ),
            Container(
              margin: const EdgeInsets.only(right: 50 * 3),
              height: kToolbarHeight,
              child: MoveWindow(),
            ),
          ],
        ),
      );

  Widget get secondaryToobar => SizedBox(
        width: double.maxFinite,
        height: kToolbarHeight,
        child: secondaryToolbarWidget,
      );

  Widget toolbar(BuildContext context) => Container(
        height: kToolbarHeight,
        width: double.maxFinite,
        padding: const EdgeInsets.only(left: 12),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...actions,
                  const Hero(tag: 'window_button', child: WindowsButtons()),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Text(
                title ?? "",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      );
}
