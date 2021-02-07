import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ruminate/models/data_model.dart';
import 'package:ruminate/models/model.dart';
import 'package:ruminate/utils/thumbnail_widget.dart';

class FolderMusicPage extends StatefulWidget {
  FolderMusicPage({Key key, @required this.dataBox}) : super(key: key);

  Box<DataModel> dataBox;

  @override
  _FolderMusicPageState createState() => _FolderMusicPageState();
}

class _FolderMusicPageState extends State<FolderMusicPage> {
  List<FolderModel> folder = [];
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
        data.sort((a, b) => a.folder.compareTo(b.folder));
        for (DataModel entity in data) {
          if (folder
              .where((element) => element.folder == entity.folder)
              .isEmpty) {
            folder.add(FolderModel(folder: entity.folder, songs: [entity]));
          } else {
            int i =
                folder.indexWhere((element) => element.folder == entity.folder);
            if (folder[i].songs.where((element) => element == entity).isEmpty) {
              folder[i].songs.add(entity);
            }
          }
        }
        folder.sort((a, b) => a.folder.compareTo(b.folder));
        return ListView.builder(
          itemCount: folder.length,
          itemBuilder: (_, index) {
            return Card(
              child: OpenContainerWidget(
                primaryTitle: folder[index].folder,
                songs: folder[index].songs,
              ),
            );
          },
        );
      },
    );
  }
}

class OpenContainerWidget extends StatelessWidget {
  const OpenContainerWidget({Key key, this.primaryTitle, this.songs})
      : super(key: key);

  final String primaryTitle;
  final List<DataModel> songs;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openColor: Colors.black,
      closedColor: Colors.grey[900],
      transitionDuration: Duration(milliseconds: 400),
      closedBuilder: (context, action) => ListTile(
        title: Text(primaryTitle),
        subtitle: Text(
          songs.length == 1 ? "1 song" : "${songs.length} songs",
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
        ),
        // onTap: () {},
      ),
      openBuilder: (context, action) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(primaryTitle),
          actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: () {})],
        ),
        body: ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {},
              leading: songs[index].complete == true
                  ? CircleAvatar(child: Icon(Icons.music_note))
                  : CircleAvatar(
                      child: Thumbnail().imageThumbnail(
                          songs[index].path.hashCode, BoxFit.scaleDown)),
              title: Text(songs[index].title),
              subtitle: Text(songs[index].artist),
            );
          },
        ),
      ),
    );
  }
}
