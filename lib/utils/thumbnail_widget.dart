import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../main.dart';

class Thumbnail {
  FutureBuilder imageThumbnail(int id, BoxFit boxFit) {
    return FutureBuilder(
        future: getThumb(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            if (snapshot.data != null) {
              return Hero(tag: "hero",child: Image.memory(snapshot.data));
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

  Future<Uint8List> getThumb(int id) async {
    return (await thumb.get(id));
  }
}
