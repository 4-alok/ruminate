import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Ruminate/models/data_model.dart';
import 'package:Ruminate/screens/widget/appBar.dart';
import 'package:Ruminate/screens/widget/scroll_bar_controller.dart';
import 'package:Ruminate/screens/widget/song_widget.dart';
import '../../utils/audio_service.dart';

class MusicListPage extends StatefulWidget {
  MusicListPage({Key key, @required this.dataBox}) : super(key: key);

  Box<DataModel> dataBox;

  @override
  _MusicListPageState createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MusicListPage> {
  final GlobalKey menuKey = new GlobalKey();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<DataModel>>(
      valueListenable: widget.dataBox.listenable(),
      builder: (context, Box<DataModel> items, _) {
        if (items == null || items.length == 0) {
          return Container(
            child: Center(child: Text("No Data Found")),
          );
        }
        List<DataModel> data = items.values.toList().cast<DataModel>();

        // data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return ValueListenableBuilder<Sorting>(
            valueListenable: sorting,
            builder: (context, snapshot, child) {
              if (snapshot == Sorting.date) {
                data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              } else if (snapshot == Sorting.album) {
                data.sort((a, b) => a.album.compareTo(b.album));
              } else if (snapshot == Sorting.artist) {
                data.sort((a, b) => a.artist.compareTo(b.artist));
              } else if (snapshot == Sorting.name) {
                data.sort((a, b) => a.title.compareTo(b.title));
              } else {
                data.sort((a, b) => a.title.compareTo(b.title));
              }
              return ScrollBarControl(
                controller: _scrollController,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: data.length,
                  itemBuilder: (_, i) {
                    return musicTile(
                        context,
                        data[i].complete,
                        data[i].path.hashCode,
                        data[i].title == "" ? data[i].path : data[i].title,
                        data[i].artist == '' ? "<unknown>" : data[i].artist,
                        () {
                      initPlayList(data, i);
                    });
                  },
                ),
              );
            });
      },
    );
  }
}
