import 'package:Ruminate/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Ruminate/models/data_model.dart';
import 'package:Ruminate/screens/widget/appBar.dart';
import 'package:Ruminate/screens/widget/scroll_bar_controller.dart';
import '../widget/song_widget.dart';
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

        return ValueListenableBuilder<Sorting>(
            valueListenable: sorting,
            builder: (context, snapshot, child) {
              List<DataModel> onScreenList = sort(data, snapshot);
              return ScrollBarControl(
                controller: _scrollController,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: onScreenList.length,
                  itemBuilder: (_, i) {
                    return musicTile(
                        context,
                        onScreenList[i].complete,
                        onScreenList[i].path.hashCode,
                        onScreenList[i].title == ""
                            ? onScreenList[i].path
                            : onScreenList[i].title,
                        onScreenList[i].artist == ''
                            ? "<unknown>"
                            : onScreenList[i].artist, () {
                      setPlayList(onScreenList);
                      playAudio(i);
                    });
                  },
                ),
              );
            });
      },
    );
  }

  List<DataModel> sort(List<DataModel> data, Sorting snapshot) {
    if (snapshot == Sorting.date) {
      data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return data;
    } else if (snapshot == Sorting.name) {
      data.sort((a, b) => a.title.compareTo(b.title));
      return data;
    } else if (snapshot == Sorting.fav) {
      List l = favList.values.toList();
      // List<DataModel> k = [];
      return data.where((element) => l.contains(element.path)).toList();
      // for (DataModel s in data) {
      //   if (l.contains(s.path)) {
      //     k.add(s);
      //   }
      // }
      // return k;
    } else {
      data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return data;
    }
  }
}
