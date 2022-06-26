import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ruminate/core/services/hive_database/hive_database_impl.dart';
import 'package:ruminate/core/services/hive_database/model/genere.dart';

import '../../../core/di/di.dart';
import '../../../global/widgets/base/large_screen_base.dart';
import '../../../routes/app_router.dart';

class GenerePage extends StatelessWidget {
  const GenerePage({Key? key}) : super(key: key);

  String tileSubtitle(Genere artist) {
    final count = artist.songs.length;
    return count == 1 ? "1 song" : "$count songs";
  }

  @override
  Widget build(BuildContext context) => LargeScreenBase(
        title: "Genres",
        secondaryToolbar: secondaryToolBar(context),
        body: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight * 2 + 10),
          child: body(),
        ),
      );

  Widget body() => FutureBuilder<List<Genere>>(
        future: locator<HiveDatabase>().getGenresList,
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
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onTap: () => Navigator.pushNamed(
                                context,
                                Routes.GENERE_SONGS,
                                arguments: artist,
                              ),
                              title: Text(artist.name == ""
                                  ? "Unknown Genre"
                                  : artist.name),
                              subtitle: Text(tileSubtitle(artist)),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      );

  Widget secondaryToolBar(BuildContext context) => Row(
        children: [
          Hero(
            tag: "genere_play",
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
            tag: 'genere_shuffle',
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
