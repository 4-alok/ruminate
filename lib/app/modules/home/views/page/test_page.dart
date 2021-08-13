import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:ruminate/app/utils/get_meta.dart';
import 'package:ruminate/app/utils/find_songs.dart';
import 'package:ruminate/app/utils/database_model.dart';
import 'package:ruminate/app/services/database_service.dart';

class TestPage extends StatelessWidget {
  final SongDatabaseService songDatabase = Get.find<SongDatabaseService>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                child: Text('Find Songs'),
                onPressed: () async {
                  for (String path in (await FindSong().findSong())) {
                    print(path);
                  }
                },
              ),
              ElevatedButton(
                child: Text('Length'),
                onPressed: () async {
                  print((await FindSong().findSong()).length);
                },
              ),
              ElevatedButton(
                child: Text('Test'),
                onPressed: () async {
                  final List<FileSystemEntity> list =
                      await Directory('/home/alok').list().toList();
                  for (FileSystemEntity entity in list) {
                    print(entity.path);
                  }
                },
              ),
              ElevatedButton(
                child: Text('Meta'),
                onPressed: () async {
                  final String p =
                      "home/alok/Warpinator/Arash feat. Helena - One Night in Dubai [Bass Boosted] [NVC Music] [Dubai Showtime].mp3";
                  print(await File(p).exists());
                  var k = Media.file(
                    File(p),
                    parse: true,
                  ).metas;
                  print(k);
                },
              ),
              ElevatedButton(
                child: Text('Check Meta Data'),
                onPressed: () async {
                  final List<String> songs = await FindSong().findSong();
                  final List<Song> s = await VlcMeta().getSongsMetadata(songs);
                  print(s.length);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await songDatabase.updateDatabase();
                },
                child: Text("Add"),
              ),
              ElevatedButton(
                onPressed: () async {
                  File file = File(
                      '/home/alok/.cache/vlc/art/artistalbum/Billy%20X/Baadshah/art.jpg');
                  print(file.existsSync());
                },
                child: Text("Length"),
              ),
              ElevatedButton(
                onPressed: () {
                  songDatabase.clearDatabase();
                },
                child: Text("Clear"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
