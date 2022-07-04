import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ruminate/core/services/hive_database/hive_database_impl.dart';
import 'package:ruminate/core/services/hive_database/model/genere.dart';
import 'package:ruminate/core/services/music_player_service/music_player_service.dart';

import '../../../core/di/di.dart';
import '../../../core/services/app_services/app_service.dart';
import '../../../global/widgets/base/large_screen_base.dart';
import '../../../routes/app_router.dart';

class GenerePage extends StatefulWidget {
  const GenerePage({Key? key}) : super(key: key);

  @override
  State<GenerePage> createState() => _GenerePageState();
}

class _GenerePageState extends State<GenerePage> {
  List<Genere> _genereList = [];

  String tileSubtitle(Genere artist) {
    final count = artist.songs.length;
    return count == 1 ? "1 song" : "$count songs";
  }

  AppService get appService => locator<AppService>();

  @override
  Widget build(BuildContext context) => LargeScreenBase(
        title: "Genres",
        secondaryToolbar: secondaryToolBar(context),
        body: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight * 2 + 10),
          child: body,
        ),
      );

  Widget get body => FutureBuilder<List<Genere>>(
        future: locator<HiveDatabase>().getGenresList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LinearProgressIndicator();
          } else {
            _genereList = snapshot.data ?? [];
            return AnimationLimiter(
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
            );
          }
        },
      );

  Widget secondaryToolBar(BuildContext context) => Row(
        children: [
          Hero(
            tag: "genere_play",
            child: TextButton(
              onPressed: () =>
                  locator<MusicPlayerService>().playGenres(_genereList),
              child: Row(
                children: const [
                  Icon(Icons.play_arrow),
                  SizedBox(width: 5),
                  Text("Play All"),
                ],
              ),
            ),
          ),
          // Hero(
          //   tag: 'genere_shuffle',
          //   child: TextButton(
          //     onPressed: () {},
          //     child: Row(
          //       children: const [
          //         Icon(Icons.shuffle),
          //         SizedBox(width: 5),
          //         Text("Shuffle"),
          //       ],
          //     ),
          //   ),
          // ),
          // TextButton(
          //   onPressed: () => appService.panelController.show(),
          //   child: const Text("Show"),
          // ),
          // TextButton(
          //   onPressed: () => appService.panelController.open(),
          //   child: const Text("Open"),
          // ),
          // TextButton(
          //   onPressed: () => appService.panelController.hide(),
          //   child: const Text("Hide"),
          // ),
          // TextButton(
          //   onPressed: () => appService.panelController.close(),
          //   child: const Text("Close"),
          // ),
        ],
      );
}
