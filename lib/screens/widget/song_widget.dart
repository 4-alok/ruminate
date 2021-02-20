import 'package:flutter/material.dart';
import 'package:ruminate/utils/thumbnail_widget.dart';

Widget musicTile(bool icon, int id, String title, String subtitle,
    Function trallingFunction, Function onTapFunction) {
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
      trailing: IconButton(
        onPressed: trallingFunction,
        icon: Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
      ),
      onTap: onTapFunction);
}
