import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ruminate/core/di/di.dart';
import 'package:ruminate/core/services/app_services/app_service.dart';

import '../../../../core/services/hive_database/model/album.dart';
import '../../../../global/widgets/thumbnail_image.dart';

class AlbumSongsBody extends StatelessWidget {
  final Album album;
  final Uint8List? imgData;
  const AlbumSongsBody({required this.album, required this.imgData, Key? key})
      : super(key: key);

  double get drawerWidth => locator<AppService>().isAppDrawerOpen ? 270 : 50;

  @override
  Widget build(BuildContext context) {
    final bodyWidth = MediaQuery.of(context).size.width - drawerWidth;
    return Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight * 2),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 100),
          child: SizedBox(
            width: bodyWidth,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 400,
                  height: 550,
                  child: albumArt,
                ),
                SizedBox(
                  width: songTileWidth(bodyWidth),
                  child: albumSongList(),
                )
              ],
            ),
          ),
        ));
  }

  double songTileWidth(double bodyWidth) =>
      bodyWidth < 1200 ? bodyWidth - 420 : 775;

  ListView albumSongList() => ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: album.songs.length,
        itemBuilder: (context, index) => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {},
            leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: FaIcon(
                  FontAwesomeIcons.play,
                  color: Theme.of(context).primaryColor,
                )),
            title: Text(
              album.songs[index].title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              album.songs[index].artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(album.songs[index].duration),
          ),
        ),
      );

  Card get albumArt => Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ThumbnailImage(
              path: album.artPath,
              imageData: imgData,
            )),
      );
}
