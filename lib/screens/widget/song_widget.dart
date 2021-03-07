import 'package:Ruminate/utils/thumbnail_manager.dart';
import 'package:flutter/material.dart';
import 'song_details.dart';

Widget musicTile(BuildContext context, bool icon, int id, String title,
    String subtitle, String path, Function onTapFunction) {
  return ListTile(
      leading: icon == true
          ? CircleAvatar(child: Icon(Icons.music_note))
          : CircleAvatar(child: Thumbnail().imageThumbnail(id, BoxFit.cover)),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        subtitle,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      // trailing: GestureDetector(
      //     onTapDown: (TapDownDetails details) async {
      //       await showPopupMenu(context, details);
      //     },
      //     child: CircleAvatar(
      //       backgroundColor: Colors.transparent,
      //       child: Icon(
      //         Icons.more_vert,
      //         color: Colors.white,
      //       ),
      //     )),
      trailing: PopupMenuButton(
        icon: Icon(Icons.more_vert),
        itemBuilder: (context) => [
          // PopupMenuItem(child: Text("Play Next"), value: 'n'),
          PopupMenuItem(child: Text("Song Details"), value: 'd'),
        ],
        onSelected: (val) {
          switch (val) {
            case "n":
              // Todo: Add to Playlist
              break;
            case "d":
              return showDiaglog(context, path);
            default:
          }
        },
      ),
      onTap: onTapFunction);
}

showDiaglog(BuildContext context, String path) {
  showDialog(
      context: (context),
      builder: (context) {
        return SongDetails(path: path);
      });
}
