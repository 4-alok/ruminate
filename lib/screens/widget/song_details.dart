import 'dart:typed_data';

import 'package:Ruminate/models/model.dart';
import 'package:Ruminate/utils/database.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:flutter/material.dart';

class SongDetails extends StatefulWidget {
  const SongDetails({
    Key key,
    @required this.path,
  }) : super(key: key);

  final String path;

  @override
  _SongDetailsState createState() => _SongDetailsState();
}

class _SongDetailsState extends State<SongDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 150, bottom: 200),
      child: Center(
          child: Material(
        // borderRadius: BorderRadius.circular(20),
        child: FutureBuilder<AudioDetails>(
            future: MusicDatabase().getSongDetails(widget.path),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      pinned: false,
                      leading: Container(),
                      expandedHeight: 200,
                      flexibleSpace: FlexibleSpaceBar(
                        background: FutureBuilder(
                          future: getImage(widget.path),
                          builder: (context, img) {
                            if (img.hasData) {
                              return Image.memory(
                                img.data,
                                fit: BoxFit.fitWidth,
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      ListTile(
                        title: Text(snapshot.data.title),
                      ),
                      ListTile(
                        title: Text(snapshot.data.artist),
                      ),
                      ListTile(
                        title: Text(snapshot.data.album),
                      ),
                      ListTile(
                        title: Text(snapshot.data.albumArtist),
                      ),
                      ListTile(
                        title: Text(snapshot.data.year),
                      ),
                      ListTile(
                        title: Text(snapshot.data.genre),
                      ),
                      ListTile(
                        title: Text(snapshot.data.discNumber +
                            " / " +
                            snapshot.data.discTotal),
                      ),
                      ListTile(
                        subtitle: Text(snapshot.data.lyrics),
                      ),
                    ]))
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      )),
    );
  }

  Future<Uint8List> getImage(String path) async {
    final tagger = new Audiotagger();
    return await tagger.readArtwork(path: path);
  }
}
