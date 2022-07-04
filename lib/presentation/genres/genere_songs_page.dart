import 'package:flutter/material.dart';
import 'package:ruminate/core/services/hive_database/model/genere.dart';

import '../../../global/widgets/base/large_screen_base.dart';
import '../../../global/widgets/thumbnail_image.dart';
import '../../core/di/di.dart';
import '../../core/services/music_player_service/music_player_service.dart';

class GenereSongsPage extends StatefulWidget {
  const GenereSongsPage({Key? key}) : super(key: key);

  @override
  State<GenereSongsPage> createState() => _GenereSongsPageState();
}

class _GenereSongsPageState extends State<GenereSongsPage> {
  Genere getGenere(BuildContext context) =>
      ModalRoute.of(context)!.settings.arguments as Genere;

  @override
  Widget build(BuildContext context) {
    final genere = getGenere(context);

    return LargeScreenBase(
        title: genere.name,
        secondaryToolbar: secondaryToolBar(context),
        body: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight * 2),
          child: ListView.builder(
            itemCount: genere.songs.length,
            itemBuilder: (context, index) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () => locator<MusicPlayerService>()
                    .playGenre(genere, index: index),
                leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: ThumbnailImage(
                        width: 50, path: genere.songs[index].path)),
                title: Text(genere.songs[index].title),
                subtitle: Text(genere.songs[index].artist),
                trailing: Text(genere.songs[index].duration),
              ),
            ),
          ),
        ));
  }

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
            tag: "genere_play",
            child: TextButton(
              onPressed: () =>
                  locator<MusicPlayerService>().playGenre(getGenere(context)),
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
            tag: 'genere_shuffle',
            child: TextButton(
              onPressed: () => locator<MusicPlayerService>()
                  .playGenre(getGenere(context), shuffle: true),
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
