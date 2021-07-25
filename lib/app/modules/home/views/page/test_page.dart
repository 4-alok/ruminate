import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruminate/app/services/database_service.dart';
import 'package:ruminate/app/utils/generate_thumbnails.dart';

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Music Database"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                child: Text('Length'),
                onPressed: () {
                  print(songDatabase.songBox.length);
                },
              ),
              ElevatedButton(
                child: Text('Clear'),
                onPressed: () {
                  songDatabase.songBox.clear();
                },
              ),
              ElevatedButton(
                child: Text('Update'),
                onPressed: () {
                  songDatabase.updateDatabase();
                },
              ),
              ElevatedButton(
                child: Text('F4'),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Thumbnail Database"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                child: Text('Add'),
                onPressed: () {
                  GenerateThumbnails().generateThumbnails();
                },
              ),
              ElevatedButton(
                child: Text('Length'),
                onPressed: () async {
                  print(songDatabase.thumbnailsBox.length);
                },
              ),
              ElevatedButton(
                child: Text('F3'),
                onPressed: () async {},
              ),
              ElevatedButton(
                child: Text('Clear'),
                onPressed: () {
                  songDatabase.thumbnailsBox.clear();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
