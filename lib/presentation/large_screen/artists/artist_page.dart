import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ruminate/core/di/di.dart';
import 'package:ruminate/core/services/hive_database/hive_database_impl.dart';

import '../../../core/services/hive_database/model/artist.dart';
import '../../../global/widgets/base/large_screen_base.dart';
import '../../../routes/app_router.dart';

class ArtistPage extends StatelessWidget {
  const ArtistPage({Key? key}) : super(key: key);

  String tileSubtitle(Artist artist) {
    final count = artist.songs.length;
    return count == 1 ? "1 song" : "$count songs";
  }

  @override
  Widget build(BuildContext context) => LargeScreenBase(
        title: "Artists",
        secondaryToolbar: secondaryToolBar(context),
        body: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight * 2 + 10),
          child: body(),
        ),
      );

  Widget body() => FutureBuilder<List<Artist>>(
        future: locator<HiveDatabase>().getArtistsList,
        builder: (context, snapshot) => !snapshot.hasData
            ? const LinearProgressIndicator()
            : AnimationLimiter(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final artist = snapshot.data![index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: songTile(context, artist),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      );

  ListTile songTile(BuildContext context, Artist artist) => ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () => Navigator.pushNamed(
          context,
          Routes.ARTIST_SONGS,
          arguments: artist,
        ),
        title: Text(
            artist.artistName == "" ? "Unknown Artist" : artist.artistName),
        subtitle: Text(tileSubtitle(artist)),
      );

  Widget secondaryToolBar(BuildContext context) => Row(
        children: [
          Hero(
            tag: "artist_play",
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
            tag: 'artist_shuffle',
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
