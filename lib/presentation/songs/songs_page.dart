import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ruminate/core/di/di.dart';
import 'package:ruminate/core/services/app_services/app_service.dart';
import 'package:ruminate/core/services/music_player_service/music_player_service.dart';
import 'package:ruminate/global/widgets/thumbnail_image.dart';

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
              child: AnimationLimiter(
                child: songsList(box, songs),
              ),
            ),
          );
        },
      );

  Widget songsList(Box<Song> box, List<Song> songs) => ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: box.length,
        itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
          position: index,
          child: SlideAnimation(
            verticalOffset: 44.0,
            child: FadeInAnimation(
              child: songTile(songs[index], index),
            ),
          ),
        ),
      );

  Widget songTile(Song song, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            onTap: () => musicPlayerService.playSongs(songs, index: index),
            leading: SizedBox(
                height: 50,
                width: 50,
                child: ThumbnailImage(width: 50, path: song.path)),
            title: Text((song.title),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              song.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(song.duration),
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
