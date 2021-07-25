import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/instance_manager.dart';
import 'package:ruminate/app/services/database_service.dart';

class ThumbnailImage {
  static Future<Uint8List?> getThumb(int id) async {
    final SongDatabaseService songDatabase = Get.find<SongDatabaseService>();
    return await songDatabase.thumbnailsBox.get(id);
  }

  static Widget image(int id) => FutureBuilder<Uint8List?>(
        future: getThumb(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Icon(Icons.music_note_rounded));
          }
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!);
          } else {
            return const Center(child: Icon(Icons.music_note_rounded));
          }
        },
      );
}
