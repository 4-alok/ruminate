import 'dart:io';
import 'dart:typed_data';
import 'package:audiotagger/audiotagger.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ruminate/models/data_model.dart';

class MusicDatabase {
  Box<DataModel> dataBox = Hive.box<DataModel>("data");
  final tagger = new Audiotagger();

  getAudio() async {
    for (Directory storagePath in (await getExternalStorageDirectories())) {
      Directory dir = Directory(storagePath.path.split('Android')[0]);
      getFiles(dir);
    }
  }

  void getFiles(Directory dir) async {
    try {
      for (FileSystemEntity entity in (dir.listSync(recursive: false, followLinks: false))) {
        if (entity is File) {
          if (entity.path.endsWith('.mp3')) {
            if (dataBox.isEmpty) {
              await generateThumbnail(entity.path);
              addSongToBox(entity.path);
            } else {
              if (dataBox.values
                  .where((element) => element.path == entity.path)
                  .isEmpty) {
                await generateThumbnail(entity.path);
                addSongToBox(entity.path);
              }
            }
          }
        }
        if (entity is Directory) {
          if (!entity.path.contains('WhatsApp/Media') &&
              !entity.path.contains('/Android') &&
              !entity.path.contains('/.')) {
            getFiles(entity);
          }
        }
      }
    } catch (e) {}
  }

  addSongToBox(String path) async {
    final Map map = await tagger.readTagsAsMap(path: path);
    
    DataModel data = DataModel(
      path: path,
      title:
          map['title'] == "" ? File(path).uri.pathSegments.last : map['title'],
      artist: map['artist'],
      album: map['album'] == ""
          ? File(path).parent.path.split('/').last
          : map['album'],
      albumArtist: map['albumArtist'],
      year: map['year'],
      folder: File(path).parent.path.split('/').last,
      createdAt: await File(path).lastModified(),
      complete: map['title'] == "" ? true : false,
    );
    dataBox.add(data);
  }

  printHive() {
    if (dataBox.isNotEmpty) {
      for (DataModel entity in dataBox.values) {
        print(" -->${entity.path} ${entity.title} \n");
      }
    }
  }

  generateThumbnail(String path) async {
    final doc = (await getExternalStorageDirectories())[0].path;
    final file = File(doc + '/${path.hashCode}');
    if (!(await file.exists())) {
      try {
        final Uint8List bytes = await tagger.readArtwork(path: path);
        if (bytes != null) {
          file.writeAsBytes(bytes);
        }
      } catch (e) {}
    }
  }
}
