import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ruminate/models/data_model.dart';
import 'package:ruminate/models/model.dart';
import 'package:ruminate/screens/widget/animated_container.dart';
import 'package:ruminate/screens/widget/scroll_bar_controller.dart';

class ArtistPage extends StatefulWidget {
  ArtistPage({Key key, @required this.dataBox}) : super(key: key);

  Box<DataModel> dataBox;

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  final ScrollController _scrollController = ScrollController();
  List<ArtistModel> artist = [];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.dataBox.listenable(),
      builder: (context, Box<DataModel> items, _) {
        if (items == null || items.length == 0) {
          return Container(
            child: Center(child: Text("No Data Found")),
          );
        }
        _sortArtist(items);
        return ScrollBarControl(
          controller: _scrollController,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: artist.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              return Card(
                child: OpenContainerWidget(
                  primaryTitle: artist[index].artist == ""
                      ? "<unknown-artist>"
                      : artist[index].artist,
                  songs: artist[index].songs,
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _sortArtist(Box<DataModel> items) {
    List<DataModel> data = items.values.toList().cast<DataModel>();
    for (DataModel entity in data) {
      if (artist.where((element) => element.artist == entity.artist).isEmpty) {
        artist.add(ArtistModel(artist: entity.artist, songs: [entity]));
      } else {
        int i = artist.indexWhere((element) => element.artist == entity.artist);
        if (artist[i].songs.where((element) => element == entity).isEmpty) {
          artist[i].songs.add(entity);
        }
      }
    }
    artist.sort((a, b) => a.artist.compareTo(b.artist));
  }
}