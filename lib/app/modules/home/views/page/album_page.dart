import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruminate/app/services/database_service.dart';

class AlbumPage extends StatelessWidget {
  final SongDatabase songDatabase = Get.find<SongDatabase>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: songDatabase.songBox.length,
        itemBuilder: (context, index) => Card(
          child: Container(
            height: 200,
            color: Colors.green,
            padding: EdgeInsets.all(10),
            child: FutureBuilder<Uint8List?>(
              future: getThumb(
                  songDatabase.songBox.values.toList()[index].path.hashCode),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  
                  return Image.memory(snapshot.data!);
                } else {
                  return Center(child: Text('Error'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
  Future<Uint8List?> getThumb(int id) async {
    return await songDatabase.thumbnailsBox.get(id);
  }
}
