import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../main.dart';

class Thumbnail {
  FutureBuilder imageThumbnail(int id, BoxFit boxFit) {
    return FutureBuilder(
        future: getThumb(id),
        builder: (context, snapshot) {
          Widget dynWidget = Center(child: Icon(Icons.music_note));
          if (snapshot.connectionState != ConnectionState.waiting) {
            if (snapshot.data != null) {
              dynWidget = Image.memory(snapshot.data);
              return AnimatedSwitcher(
                duration: Duration(seconds: 1),
                child: dynWidget,
              );
            } else {
              return dynWidget;
            }
          } else {
            return dynWidget;
          }
        });
  }

  Future<Uint8List> getThumb(int id) async {
    return (await thumb.get(id));
  }
}
