import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:ruminate/app/services/database_service.dart';

class GlobalWidget {
  static Widget image(String path, [double scale = 1]) {
    final SongDatabaseService songDatabase = Get.find<SongDatabaseService>();
    if (path != "") {
      final img = songDatabase.thumbnails
          .get(path.hashCode) as Uint8List?;
      if (img != null) {
        return FadeInImage(
          fadeInDuration: Duration(milliseconds: 200),
          placeholder: MemoryImage(songDatabase.imgThumb),
          image: MemoryImage(img, scale: scale),
          imageErrorBuilder: (_, __, ___) =>
              Image.memory(songDatabase.imgThumb),
        );
      }
    }
    return Image.memory(songDatabase.imgThumb);
  }
}
