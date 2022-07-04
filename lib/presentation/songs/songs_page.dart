import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ruminate/core/di/di.dart';
import 'package:ruminate/core/services/app_services/app_service.dart';
import 'package:ruminate/core/services/music_player_service/music_player_service.dart';
import 'package:ruminate/presentation/songs/song_tile.dart';

import '../../../core/services/hive_database/hive_database_impl.dart';
import '../../../core/services/hive_database/model/song.dart';
import '../../../global/widgets/base/large_screen_base.dart';
import '../../../global/widgets/refresh_widget.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({Key? key}) : super(key: key);

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  MusicPlayerService get musicPlayerService => locator<MusicPlayerService>();
  List<Song> songs = [];

  @override
  Widget build(BuildContext context) => LargeScreenBase(
        title: "Songs",
        actions: actions,
        secondaryToolbar: secondaryToolBar(context),
        body: ValueListenableBuilder<bool>(
          valueListenable: locator<AppService>().databaseUpadting,
          builder: (context, value, child) =>
              value ? const LinearProgressIndicator() : child!,
          child: body,
        ),
      );

  Widget get body => ValueListenableBuilder<Box<Song>>(
        valueListenable:
            locator<HiveDatabase>().datasource.songBox.listenable(),
        builder: (context, box, child) {
          songs = box.values.toList();
          songs.sort((b, a) => b.title.compareTo(a.title));
          return Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight * 2 + 10),
            child: Scrollbar(
              thumbVisibility: true,
              child: songListTable(context, songs),
              // child: songsList(songs),
            ),
          );
        },
      );

  Widget songListTable(BuildContext context, List<Song> songs) =>
      AnimationLimiter(
        child: ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: AnimationConfiguration.staggeredList(
              duration: const Duration(milliseconds: 200),
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: SongTile(
                    song: songs[index],
                    index: index,
                    onTap: () =>
                        musicPlayerService.playSongs(songs, index: index),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  List<Widget> get actions => [const RefreshWidget()];

  Widget secondaryToolBar(BuildContext context) => Row(
        children: [
          TextButton(
            onPressed: () => musicPlayerService.playSongs(songs),
            child: Row(
              children: const [
                Icon(Icons.play_arrow),
                SizedBox(width: 5),
                Text("Play"),
              ],
            ),
          ),
          TextButton(
            onPressed: () => musicPlayerService.playSongs(songs, shuffle: true),
            child: Row(
              children: const [
                Icon(Icons.shuffle),
                SizedBox(width: 5),
                Text("Shuffle"),
              ],
            ),
          ),
          TextButton(
            onPressed: () => musicPlayerService.audioService.stop(),
            child: const Text("Stop"),
          ),
        ],
      );
}
