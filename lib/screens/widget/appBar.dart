import 'package:flutter/material.dart';
import './../../utils/audio_service.dart';

final ValueNotifier<Sorting> sorting = ValueNotifier<Sorting>(Sorting.name);

List<Widget> appbar = [
  ListTile(
    title: Text('Music',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PopupMenuButton<Sorting>(
          icon: Icon(Icons.sort),
          itemBuilder: (BuildContext bc) => [
            PopupMenuItem(child: Text("Name"), value: Sorting.name),
            PopupMenuItem(child: Text("Artist"), value: Sorting.artist),
            PopupMenuItem(child: Text("Album"), value: Sorting.album),
            PopupMenuItem(child: Text("Date"), value: Sorting.date),
          ],
          // color: Colors.black,
          onSelected: (sort) {
            sorting.value = sort;
          },
        ),
        IconButton(icon: Icon(Icons.settings), onPressed: () {}),
      ],
    ),
  ),
  ListTile(
      title: Text('Album',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
  ListTile(
      title: Text('Artist',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
  ListTile(
      title: Text('Folder',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
];
