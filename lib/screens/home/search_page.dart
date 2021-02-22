import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:Ruminate/models/data_model.dart';
import 'package:Ruminate/models/model.dart';
import 'package:Ruminate/screens/widget/animated_container.dart';
import 'package:Ruminate/screens/widget/song_widget.dart';
import 'package:Ruminate/utils/audio_service.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ValueNotifier<String> searchWord = ValueNotifier<String>('');
  List<DataModel> songs = [];
  List<DataModel> songResult = [];
  List<ArtistModel> artistResult = [];
  List<AlbumModel> albumResult = [];

  @override
  void initState() {
    songs = Hive.box<DataModel>('data').values.toList().cast<DataModel>();
    super.initState();
  }

  @override
  void dispose() {
    searchWord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            autofocus: true,
            style: TextStyle(fontSize: 20),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Search",
            ),
            onChanged: (val) {
              val != null ? _search(val) : _resetVal();
            },
            onSubmitted: (val) {
              val != null ? _search(val) : _resetVal();
            },
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: searchWord,
          builder: (context, snapshot, child) {
            return snapshot.length == 0
                ? Container(
                    child: Center(
                      child: Icon(
                        Icons.search,
                        size: 80,
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                  )
                : (songResult.length == 0 &&
                        artistResult.length == 0 &&
                        albumResult.length == 0)
                    ? Container(
                        child: Center(child: Text("No found")),
                      )
                    : ListView(children: <Widget>[
                        songResult.isEmpty
                            ? Container()
                            : searchTitle(context, "Song"),
                        ...songResult
                            .map(
                              (e) => musicTile(context, e.complete,
                                  e.path.hashCode, e.title, e.artist, () {
                                initPlayList([e], 0);
                              }),
                            )
                            .toList(),
                        albumResult.isEmpty
                            ? Container()
                            : searchTitle(context, "Album"),
                        ...albumResult
                            .map((e) => Card(
                                  child: OpenContainerWidget(
                                    primaryTitle: e.albumName,
                                    songs: e.songs,
                                  ),
                                ))
                            .toList(),
                        artistResult.isEmpty
                            ? Container()
                            : searchTitle(context, "Artist"),
                        ...artistResult
                            .map((e) => Card(
                                  child: OpenContainerWidget(
                                    primaryTitle: e.artist,
                                    songs: e.songs,
                                  ),
                                ))
                            .toList(),
                      ]);
          },
        ));
  }

  Padding searchTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  void _search(String val) async {
    searchWord.value = val;

    songResult = songs
        .where((element) =>
            element.title.toLowerCase().contains(val.toLowerCase()))
        .toList();

    albumResult.clear();
    for (DataModel entity in songs
        .where((element) =>
            element.album.toLowerCase().contains(val.toLowerCase()))
        .toList()) {
      if (albumResult
          .where((element) => element.albumName == entity.album)
          .isEmpty) {
        albumResult.add(AlbumModel(albumName: entity.album, songs: [entity]));
      } else {
        int i = albumResult
            .indexWhere((element) => element.albumName == entity.album);
        albumResult[i].songs.add(entity);
      }
    }

    artistResult.clear();
    for (DataModel entity in songs
        .where((element) =>
            element.artist.toLowerCase().contains(val.toLowerCase()))
        .toList()) {
      if (artistResult
          .where((element) => element.artist == entity.artist)
          .isEmpty) {
        artistResult.add(ArtistModel(artist: entity.artist, songs: [entity]));
      } else {
        int i = artistResult
            .indexWhere((element) => element.artist == entity.album);
        artistResult[i].songs.add(entity);
      }
    }
  }

  void _resetVal() {
    songResult.clear();
    artistResult.clear();
    albumResult.clear();
  }
}
