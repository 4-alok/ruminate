import 'package:flutter/material.dart';
import 'package:ruminate/models/model.dart';
import 'package:ruminate/utils/audio_service.dart';
import 'package:ruminate/utils/thumbnail_widget.dart';

class AlbumSongsPage extends StatefulWidget {
  AlbumSongsPage({Key key, @required this.album}) : super(key: key);

  AlbumModel album;

  @override
  _AlbumSongsPageState createState() => _AlbumSongsPageState();
}

class _AlbumSongsPageState extends State<AlbumSongsPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.album.albumName);
    return Scaffold(
      body: CustomScrollView(
      slivers: [
      SliverAppBar(
        expandedHeight: 350,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(widget.album.albumName),
          background: Container(
            child: Thumbnail().imageThumbnail(
                widget.album.songs[0].path.hashCode, BoxFit.cover),
          ),
        ),
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Card(
          child: ListTile(
            leading: widget.album.songs[index].complete == true
                ? CircleAvatar(child: Icon(Icons.music_note))
                : CircleAvatar(
                    child: Thumbnail().imageThumbnail(
                        widget.album.songs[index].path.hashCode,
                        BoxFit.scaleDown)),
            title: Text(widget.album.songs[index].title),
            subtitle: Text("Artist: " +
                widget.album.songs[index].artist +
                "\n" +
                "Album: " +
                widget.album.songs[index].album),
                onTap: (){
                  initPlayList(widget.album.songs, index);
                },
          ),
        );
      }, childCount: widget.album.songs.length)),
      ],
      ),
    );
  }
}

// dr lalit kishore
// niket chaudhri