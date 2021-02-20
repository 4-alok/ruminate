import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ruminate/models/data_model.dart';
import 'package:ruminate/models/model.dart';
import 'package:ruminate/screens/widget/song_widget.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ValueNotifier<String> searchWord = ValueNotifier<String>('');
  Box<DataModel> dataBox;
  List<DataModel> songs;
  List<DataModel> songResult;
  List<ArtistModel> artistResult;
  List<DataModel> albumResult;

  @override
  void initState() {
    songs = Hive.box<DataModel>('data').values.toList().cast<DataModel>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
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
                    : ListView(children: [
                        songResult != null
                            ? searchTitle(context, "song")
                            : Container(),
                        ...songResult
                            .map(
                              (e) => musicTile(e.complete, e.path.hashCode,
                                  e.title, e.artist, () {}, () {}),
                            )
                            .toList(),
                        // artistResult != null
                        //     ? searchTitle(context, "Artist")
                        //     : Container(),
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

    // artistResult = songs
    //     .where((element) =>
    //         element.artist.toLowerCase().contains(val.toLowerCase()))
    //     .toList();

    // albumResult = songs
    //     .where((element) =>
    //         element.album.toLowerCase().contains(val.toLowerCase()))
    //     .toList();
  }

  void _resetVal() {
    songResult = [];
    artistResult = [];
    albumResult = [];
  }
}
