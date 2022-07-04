import 'package:flutter/material.dart';
import 'package:ruminate/core/services/music_player_service/music_player_service.dart';
import 'package:ruminate/global/widgets/base/large_screen_base.dart';

import '../../../core/di/di.dart';
import '../../../core/services/app_services/app_service.dart';
import '../../../core/services/hive_database/model/artist.dart';
import '../../../global/widgets/thumbnail_image.dart';

class ArtistSongsPage extends StatelessWidget {
  const ArtistSongsPage({Key? key}) : super(key: key);

  double get drawerWidth => locator<AppService>().isAppDrawerOpen ? 270 : 50;

  @override
  Widget build(BuildContext context) {
    final artist = ModalRoute.of(context)!.settings.arguments as Artist;
    return LargeScreenBase(
        title: artist.artistName,
        secondaryToolbar: secondaryToolBar(context, artist),
        body: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight * 2),
          child: ListView.builder(
            itemCount: artist.songs.length,
            itemBuilder: (context, index) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () => locator<MusicPlayerService>()
                    .playArtist(artist, index: index),
                leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: ThumbnailImage(
                        width: 50, path: artist.songs[index].path)),
                title: Text(artist.songs[index].title),
                subtitle: Text(artist.songs[index].album),
                trailing: Text(artist.songs[index].duration),
              ),
            ),
          ),
        ));
  }

  Widget secondaryToolBar(BuildContext context, Artist artist) => Row(
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              size: 35,
            ),
          ),
          Hero(
            tag: "artist_play",
            child: TextButton(
              onPressed: () => locator<MusicPlayerService>().playArtist(artist),
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
            tag: 'artist_shuffle',
            child: TextButton(
              onPressed: () => locator<MusicPlayerService>()
                  .playArtist(artist, shuffle: true),
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
