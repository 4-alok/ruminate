import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WindowsButtons extends StatelessWidget {
  const WindowsButtons({Key? key}) : super(key: key);
  static const width = 50.0;
  static const height = 40.0;

  @override
  Widget build(BuildContext context) => Material(
        child: Row(
          children: [
            SizedBox(
                height: height,
                width: width,
                child: InkWell(
                    onTap: () => appWindow.minimize(),
                    child: const Center(
                        child: FaIcon(
                      FontAwesomeIcons.windowMinimize,
                      size: 15,
                    )))),
            SizedBox(
                height: height,
                width: width,
                child: InkWell(
                    onTap: () => appWindow.maximizeOrRestore(),
                    child: const Center(
                        child: FaIcon(
                      FontAwesomeIcons.windowRestore,
                      size: 15,
                    )))),
            SizedBox(
                height: height,
                width: width,
                child: InkWell(
                    hoverColor: Colors.red,
                    onTap: () => appWindow.close(),
                    child: const Center(
                        child: FaIcon(
                      FontAwesomeIcons.xmark,
                      size: 15,
                    )))),
          ],
        ),
      );

  // Row(
  //   children: [
  //     const SizedBox(width: 5),
  //     IconButton(
  //         onPressed: () => appWindow.minimize(),
  //         icon: const FaIcon(FontAwesomeIcons.windowMinimize)),
  //     const SizedBox(width: 5),
  //     IconButton(
  //         onPressed: () => appWindow.maximizeOrRestore(),
  //         icon: const FaIcon(FontAwesomeIcons.windowRestore)),
  //     const SizedBox(width: 5),
  //     IconButton(
  //         onPressed: () => appWindow.close(),
  //         icon: const FaIcon(FontAwesomeIcons.xmark)),
  //   ],
  // );

}
