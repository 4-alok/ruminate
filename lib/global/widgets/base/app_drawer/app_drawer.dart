import 'package:flutter/material.dart';
import 'package:ruminate/global/widgets/base/app_drawer/playlist.dart';

import '../../../../core/di/di.dart';
import '../../../../core/services/app_service.dart';
import 'library.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  bool get isAppDrawerOpen =>
      locator<AppService>().isAppDrawerOpen;

  @override
  Widget build(BuildContext context) => Material(
    child: ValueListenableBuilder(
      valueListenable: locator<AppService>().appDrawerState,
      builder: (context, __, ___) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ruminate(context),
          subHeading(context, "LIBRARY"),
          AppDrawerLibrary(
            isAppDrawerOpen: isAppDrawerOpen,
          ),
          // subHeading(context, "PLAYLIST"),
          // createPlaylist(context),
          // appDrawerPlaylist(context)
        ],
      ),
    ),
  );

  Widget createPlaylist(BuildContext context) =>
      isAppDrawerOpen
          ? InkWell(
              onTap: () {},
              child: SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.playlist_add,
                          color: AppDrawerPlaylist.iconColor(context),
                        ),
                      ),
                      Text(
                        "Create",
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  )),
            )
          : InkWell(
              onTap: () {},
              child: SizedBox(
                  height: 48,
                  width: 50,
                  child: Icon(
                    Icons.playlist_add,
                    color: AppDrawerPlaylist.iconColor(context),
                  )),
            );

  Widget appDrawerPlaylist(BuildContext context) =>
      isAppDrawerOpen
          ? const AppDrawerPlaylist()
          : InkWell(
              onTap: () {},
              child: SizedBox(
                  height: 48,
                  width: 50,
                  child: Icon(
                    Icons.playlist_play_rounded,
                    size: 25,
                    color: AppDrawerPlaylist.iconColor(context),
                  )),
            );

  Padding subHeading(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isAppDrawerOpen ? 1 : 0,
          child: Text(text,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontSize: 12)),
        ),
      );

  Widget ruminate(BuildContext context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        child: isAppDrawerOpen
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Ruminate',
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.headline4,
                ))
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Icon(
                    Icons.music_note,
                    size: 39.0,
                    color: AppDrawerPlaylist.iconColor(context),
                  ),
                )),
      );
}
