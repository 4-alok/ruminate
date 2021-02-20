import 'package:flutter/material.dart';
import 'package:ruminate/screens/home/search_page.dart';
import './../../utils/audio_service.dart';

final ValueNotifier<Sorting> sorting = ValueNotifier<Sorting>(Sorting.name);

List<Widget> appbar(BuildContext context) {
  return [
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
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () => _openSearch(context)),
          IconButton(icon: Icon(Icons.settings), onPressed: () => _openSetting),
        ],
      ),
    ),
    ListTile(
      title: Text('Album',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: Icon(Icons.search), onPressed: () => _openSearch(context)),
          IconButton(icon: Icon(Icons.settings), onPressed: () => _openSetting),
        ],
      ),
    ),
    ListTile(
      title: Text('Artist',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: Icon(Icons.search), onPressed: () => _openSearch(context)),
          IconButton(icon: Icon(Icons.settings), onPressed: () => _openSetting),
        ],
      ),
    ),
    ListTile(
      title: Text('Folder',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: Icon(Icons.search), onPressed: () => _openSearch(context)),
          IconButton(icon: Icon(Icons.settings), onPressed: () => _openSetting),
        ],
      ),
    ),
  ];
}

void _openSetting() {}

void _openSearch(BuildContext context) {
  Navigator.push(context, FadeRouteBuilder(page: SearchPage()));
}

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
        );
}
