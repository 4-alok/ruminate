import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruminate/app/services/database_service.dart';

class AlbumPage extends StatelessWidget {
  final SongDatabaseService songDatabase = Get.find<SongDatabaseService>();

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
            // child: ThumbnailImage.image(
            //     songDatabase.songBox.values.toList()[index].path.hashCode),
          ),
        ),
      ),
    );
  }
}
