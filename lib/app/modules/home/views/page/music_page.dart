import 'dart:io';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ruminate/app/utils/database_model.dart';
import 'package:ruminate/app/services/database_service.dart';
import 'package:ruminate/app/services/player_controller.dart';
import 'package:ruminate/app/global/widgets/global_widget.dart';
import 'package:ruminate/app/modules/home/controllers/home_controller.dart';

class MusicPage extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final SongDatabaseService database = Get.find<SongDatabaseService>();
  final PlayerController player = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ValueListenableBuilder<Box<Song>>(
          valueListenable: database.songBox.listenable(),
          builder: (context, Box<Song> data, child) {
            if (data.values.isEmpty)
              return Center(
                child: Text("No Songs"),
              );

            return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: data.values.length,
                itemBuilder: (context, index) {
                  final Song? song = data.getAt(index);
                  return ListTile(
                    leading: GlobalWidget.image((song!.artPath ?? ""), 4),
                    title: Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(song.album),
                    trailing: Text(song.duration),
                    onTap: () {
                      player.playSingleAudio(song.path);
                    },
                  );
                });
          }),
    );
  }

  Future<File?> getImage(String? path) async {
    final File _file = File(path!);
    if (await _file.exists()) {
      return _file;
    }
  }

  Widget lead(BuildContext context, Song _song) {
    return FutureBuilder<File?>(
      future: getImage(_song.artPath),
      builder: (constext, snapshot) {
        if (snapshot.data != null && !snapshot.hasError) {
          return CircleAvatar(
            backgroundImage: FileImage(snapshot.data!),
          );
        } else {
          return Icon(Icons.music_note);
        }
      },
    );
  }
}
