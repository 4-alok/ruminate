import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Thumbnail {
  FutureBuilder imageThumbnail(int id, BoxFit boxFit) {
    return FutureBuilder(
        future: getLocalFile(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            if (snapshot.data != null) {
              return Image.file(
                snapshot.data,
                fit: boxFit,
              );
            } else {
              return Center(
                child: Icon(Icons.music_note),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<File> getLocalFile(int id) async {
    var doc = (await getExternalStorageDirectories())[0].path;

    File file = File("$doc/$id");
    if (await file.exists()) {
      return file;
    } else {
      return null;
    }
  }
}
