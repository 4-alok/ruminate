import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ruminate/core/di/di.dart';
import 'package:ruminate/core/services/app_service.dart';
import 'package:ruminate/global/widgets/thumbnail_image.dart';

import '../../../core/services/hive_database/model/song.dart';
import '../../../core/services/hive_database/hive_database_impl.dart';
import '../../../global/widgets/base/action_icon.dart';
import '../../../global/widgets/base/large_screen_base.dart';

class SongsPage extends StatelessWidget {
  const SongsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => LargeScreenBase(
        title: "Songs",
        actions: actions,
        secondaryToolbar: secondaryToolBar(context),
        body: ValueListenableBuilder<bool>(
          valueListenable: locator<AppService>().databaseUpadting,
          builder: (context, value, child) =>
              value ? const LinearProgressIndicator() : child!,
          child: body(),
        ),
      );

  Widget body() => ValueListenableBuilder<Box<Song>>(
        valueListenable: locator<HiveDatabase>().datasource.songBox.listenable(),
        builder: (context, box, child) {
          final songs = box.values.toList();
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
              child: songTile(songs[index]),
            ),
          ),
        ),
      );

  Widget songTile(Song song) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            onTap: () {},
            leading: SizedBox(
                height: 50,
                width: 50,
                child: ThumbnailImage(width: 50, path: song.path)),
            title: Text((song.title),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(song.artist),
            trailing: Text(song.duration),
          ),
        ),
      );

  List<Widget> get actions => [
        ActionIcon(
          onTap: () {},
          child: const FaIcon(FontAwesomeIcons.gear),
        ),
      ];

  Widget secondaryToolBar(BuildContext context) => Row(
        children: [
          TextButton(
            onPressed: () {},
            child: Row(
              children: const [
                Icon(Icons.play_arrow),
                SizedBox(width: 5),
                Text("Play"),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Row(
              children: const [
                Icon(Icons.shuffle),
                SizedBox(width: 5),
                Text("Shuffle"),
              ],
            ),
          ),
          // const SizedBox(width: 200),
          // TextButton(
          //     onPressed: () => locator<HiveDatabase>().length,
          //     child: const Padding(
          //       padding: EdgeInsets.all(12.0),
          //       child: Text('Length'),
          //     )),
          // const SizedBox(width: 5),
          // TextButton(
          //     onPressed: () => locator<HiveDatabase>().clearDatabase,
          //     child: const Padding(
          //       padding: EdgeInsets.all(12.0),
          //       child: Text('Clear'),
          //     )),
          // const SizedBox(width: 5),
          // TextButton(
          //     onPressed: () async =>
          //         await locator<HiveDatabase>().updateDatabase(),
          //     child: const Padding(
          //       padding: EdgeInsets.all(12.0),
          //       child: Text('Update'),
          //     )),
          // const SizedBox(width: 5),
          // TextButton(
          //     onPressed: () async {
          //       Navigator.pop(context);
          //     },
          //     child: const Padding(
          //       padding: EdgeInsets.all(12.0),
          //       child: Text('Back'),
          //     )),
        ],
      );
}
