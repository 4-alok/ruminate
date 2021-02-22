import 'package:Ruminate/utils/thumbnail_manager.dart';
import 'package:flutter/material.dart';

Widget musicTile(BuildContext context, bool icon, int id, String title,
    String subtitle, Function onTapFunction) {
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
      trailing: GestureDetector(
          onTapDown: (TapDownDetails details) async {
            await showPopupMenu(context, details);
          },
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          )),
      onTap: onTapFunction);
}

Future<String> showPopupMenu(BuildContext context, TapDownDetails details) {
  return showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
        details.globalPosition.dx, details.globalPosition.dy, 0, 0),
    items: [
      PopupMenuItem<String>(child: const Text('Play'), value: '1'),
      PopupMenuItem<String>(
          child: const Text('Play after current song'), value: 'Lion'),
      PopupMenuItem<String>(child: const Text('Song Info'), value: 'Lion'),
      PopupMenuItem<String>(child: const Text('Share'), value: 'Lion'),
      PopupMenuItem<String>(child: const Text('Edit Tags'), value: 'Lion'),
      PopupMenuItem<String>(
          child: const Text('Delete permanently'), value: 'Lion'),
    ],
    elevation: 8.0,
  );
}
