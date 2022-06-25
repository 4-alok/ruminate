import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ruminate/routes/app_router.dart';

class AppDrawerLibrary extends StatefulWidget {
  final bool isAppDrawerOpen;
  const AppDrawerLibrary({ required this.isAppDrawerOpen, Key? key}) : super(key: key);

  @override
  State<AppDrawerLibrary> createState() => _AppDrawerLibraryState();
}

class _AppDrawerLibraryState extends State<AppDrawerLibrary> {
  @override
  Widget build(BuildContext context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () => goToRoute(context, Routes.SONGS),
              leading: const FaIcon(FontAwesomeIcons.music, size: 16),
              minLeadingWidth: 10,
              title: text("Songs"),
            ),
            ListTile(
              onTap: () => goToRoute(context, Routes.ALBUMS),
              leading: const FaIcon(FontAwesomeIcons.compactDisc, size: 16),
              minLeadingWidth: 10,
              title: text("Albums"),
            ),
            ListTile(
              onTap: () => goToRoute(context, Routes.ARTISTS),
              leading: const FaIcon(FontAwesomeIcons.userLarge, size: 16),
              minLeadingWidth: 10,
              title: text("Artists"),
            ),
            ListTile(
              onTap: () => goToRoute(context, Routes.GENERES),
              leading: const FaIcon(FontAwesomeIcons.tag, size: 16),
              minLeadingWidth: 10,
              title: text("Genres"),
            ),
          ]);

  Widget text(String text) => widget.isAppDrawerOpen
      ? Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.fade,
        )
      : const SizedBox();

  Future<void> goToRoute(BuildContext context, String value) async =>
      await Navigator.pushNamedAndRemoveUntil(
          context, value, (route) => route.settings.name == '/');
}
