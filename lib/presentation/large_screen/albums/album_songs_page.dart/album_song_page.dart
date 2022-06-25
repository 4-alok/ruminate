import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/services/hive_database/model/album.dart';
import '../../../../global/widgets/base/large_screen_base.dart';
import 'album_song_body.dart';
import 'album_song_body_w600.dart';
import 'album_song_body_w800.dart';

class AlbumSongsPage extends StatelessWidget {
  const AlbumSongsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final album =
        (ModalRoute.of(context)!.settings.arguments as List)[0] as Album;
    final imgData =
        (ModalRoute.of(context)!.settings.arguments as List)[1] as Uint8List?;
    return LargeScreenBase(
      title: album.albumName,
      secondaryToolbar: secondaryToolBar(context),
      body: body(album, imgData),
    );
  }

  Widget body(Album album, Uint8List? imgData) => LayoutBuilder(
        builder: ((context, boxConstraints) {
          if (boxConstraints.maxWidth < 600) {
            return const AlbumSongsBodyW600();
          } else if (boxConstraints.maxWidth < 800) {
            return const AlbumSongsBodyW800();
          } else {
            return AlbumSongsBody(
              album: album,
              imgData: imgData,
            );
          }
        }),
      );

  Widget secondaryToolBar(BuildContext context) => Row(
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              size: 35,
            ),
          ),
          Hero(
            tag: 'play',
            child: TextButton(
              onPressed: () {},
              child: Row(
                children: const [
                  Icon(Icons.play_arrow),
                  SizedBox(width: 5),
                  Text("Play All"),
                ],
              ),
            ),
          ),
          Hero(
            tag: 'shuffle',
            child: TextButton(
              onPressed: () {},
              child: Row(
                children: const [
                  Icon(Icons.shuffle),
                  SizedBox(width: 5),
                  Text("Shuffle"),
                ],
              ),
            ),
          ),
        ],
      );
}
