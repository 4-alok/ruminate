import 'package:audiotagger/audiotagger.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ruminate/models/data_model.dart';
import 'package:ruminate/utils/thumbnail_widget.dart';
import '../../utils/audio_service.dart';

class MusicListPage extends StatefulWidget {
  MusicListPage({Key key, @required this.dataBox}) : super(key: key);

  Box<DataModel> dataBox;

  @override
  _MusicListPageState createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MusicListPage> {
  final tagger = new Audiotagger();

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
        List<DataModel> data = items.values.toList().cast<DataModel>();

        data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, i) {
            return ListTile(
              leading: data[i].complete == true
                  ? CircleAvatar(child: Icon(Icons.music_note))
                  : CircleAvatar(
                      child: Thumbnail().imageThumbnail(
                          data[i].path.hashCode, BoxFit.scaleDown)),
              title: Text(
                data[i].title == "" ? data[i].path : data[i].title,
                maxLines: 1,
              ),
              subtitle: Text(
                data[i].artist == '' ? "<unknown>" : data[i].artist,
                maxLines: 1,
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                initPlayList(data, i);
              },
            );
          },
        );
      },
    );
  }
}
