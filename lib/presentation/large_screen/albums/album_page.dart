import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../core/services/hive_database/model/album.dart';
import '../../../core/services/hive_database/utils/sort_song.dart';
import '../../../global/widgets/base/large_screen_base.dart';
import '../../../global/widgets/thumbnail_image.dart';
import '../../../routes/app_router.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => LargeScreenBase(
        title: "Albums",
        secondaryToolbar: secondaryToolBar(context),
        body: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight * 2 + 10),
          child: LayoutBuilder(
              builder: (context, constraints) => gridView(
                    constraints.maxWidth ~/ 230,
                  )),
        ),
      );

  Widget secondaryToolBar(BuildContext context) => Row(
        children: [
          Hero(
            tag: "play",
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

  Widget gridView(int crossAxisCount) => FutureBuilder<List<Album>>(
        future: SortSongsO.getAlbum(),
        builder: (context, snapshot) => !snapshot.hasData
            ? const LinearProgressIndicator()
            : AnimationLimiter(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 230 / 300,
                  ),
                  itemBuilder: (context, index) =>
                      AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1),
                    child: SlideAnimation(
                        duration: const Duration(milliseconds: 300),
                        verticalOffset: 40,
                        child: FadeInAnimation(
                            duration: const Duration(milliseconds: 300),
                            child: albumTile(context, snapshot.data![index]))),
                  ),
                ),
              ),
      );

  Widget albumTile(BuildContext context, Album album) => Padding(
      padding: const EdgeInsets.all(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            color: Theme.of(context).cardColor,
            child: Stack(
              children: [
                imageArt(album.artPath),
                albumText(album.albumName),
                inkWell(context, album),
              ],
            )),
      ));

  Widget albumText(String text) => Positioned(
      bottom: 12,
      left: 0,
      right: 0,
      child: Text(
        text == '' ? 'Unknown' : text,
        textAlign: TextAlign.center,
        maxLines: 1,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ));

  Widget imageArt(String path) => Positioned(
      top: 0,
      bottom: 50,
      left: 0,
      right: 0,
      child: ThumbnailImage(
        path: path,
        width: 230,
      ));

  Widget inkWell(BuildContext context, Album album) => Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.pushNamed(
              context,
              Routes.ALBUM_SONGS,
              arguments: [album, null],
            ),
          ),
        ),
      );
}
