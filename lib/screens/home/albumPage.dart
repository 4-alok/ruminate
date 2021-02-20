import 'dart:io';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Ruminate/models/model.dart';
import 'package:Ruminate/models/data_model.dart';
import 'package:Ruminate/screens/widget/scroll_bar_controller.dart';
import 'package:Ruminate/utils/thumbnail_widget.dart';

import 'album_song_page.dart';

class AlbumListPage extends StatefulWidget {
  AlbumListPage({
    Key key,
    @required this.dataBox,
  }) : super(key: key);

  Box<DataModel> dataBox;

  @override
  _AlbumListPageState createState() => _AlbumListPageState();
}

class _AlbumListPageState extends State<AlbumListPage> {
  List<AlbumModel> album = [];
  String doc = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getPath();
  }

  void getPath() async {
    doc = (await getExternalStorageDirectories())[0].path;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.dataBox.listenable(),
      builder: (context, Box<DataModel> items, _) {
        List<DataModel> data = items.values.toList().cast<DataModel>();
        data.sort((a, b) => a.album.compareTo(b.album));
        for (DataModel entity in data) {
          if (album
              .where((element) => element.albumName == entity.album)
              .isEmpty) {
            album.add(AlbumModel(albumName: entity.album, songs: [entity]));
          } else {
            int i = album
                .indexWhere((element) => element.albumName == entity.album);
            if (album[i].songs.where((element) => element == entity).isEmpty) {
              album[i].songs.add(entity);
            }
          }
        }

        return Container(
            child: ScrollBarControl(
              controller: _scrollController,
                          child: GridView.builder(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: album.length,
                  itemBuilder: (context, i) {
                    return Card(
                      color: Colors.grey[900],
                      child: OpenContainer(
                        closedColor: Colors.black,
                        openColor: Colors.black,
                        transitionDuration: Duration(milliseconds: 400),
                        closedBuilder: (context, action) => Stack(
                          children: [
                            Center(
                                child: Container(
                                    child: Thumbnail().imageThumbnail(
                                        album[i].songs[0].path.hashCode,
                                        BoxFit.cover))
                                // child: Image.file(''),
                                ),
                            Container(
                                padding: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Colors.transparent, Colors.black],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.5, 0.9]),
                                ),
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Text(
                                    album[i].albumName == ''
                                        ? '<unknown>'
                                        : "${album[i].albumName}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                          ],
                        ),
                        openBuilder: (context, action) => AlbumSongsPage(
                          album: album[i],
                        ),
                      ),
                    );
                  }),
            ));
      },
    );
  }
}
