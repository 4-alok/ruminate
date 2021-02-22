import 'package:Ruminate/models/data_model.dart';
import 'package:Ruminate/utils/audio_service.dart';
import 'package:Ruminate/utils/thumbnail_manager.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class OpenContainerWidget extends StatelessWidget {
  const OpenContainerWidget({Key key, this.primaryTitle, this.songs})
      : super(key: key);

  final String primaryTitle;
  final List<DataModel> songs;

  @override
  Widget build(BuildContext context) {
    songs.sort((a, b) => a.title.compareTo(b.title));
    return OpenContainer(
      openColor: Colors.black,
      closedColor: Colors.grey[900],
      transitionDuration: Duration(milliseconds: 200),
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
          physics: BouncingScrollPhysics(),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                initPlayList(songs, index);
              },
              leading: songs[index].complete == true
                  ? CircleAvatar(child: Icon(Icons.music_note))
                  : CircleAvatar(
                      child: Thumbnail().imageThumbnail(
                          songs[index].path.hashCode, BoxFit.scaleDown)),
              title: Text(songs[index].title,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text(songs[index].artist,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            );
          },
        ),
      ),
    );
  }
}
