import 'dart:io';
import 'dart:typed_data';
import 'package:Ruminate/models/data_model.dart';
import 'package:Ruminate/models/model.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart';
import '../main.dart';
import 'audio_service.dart';

class MusicDatabase {
  Box<DataModel> dataBox = Hive.box<DataModel>("data");
  final tagger = new Audiotagger();
  List<String> storage = [];
  List<String> excluded = [
    // "/storage/emulated/0/",
    "/WhatsApp/Media/",
    "/Android/data/",
    "SoundRecord",
    "./"
  ];

  Future<void> getAudio() async {
    for (Directory storagePath in (await getExternalStorageDirectories())) {
      Directory dir = Directory(storagePath.path.split('Android')[0]);
      getFiles(dir);
      storage.add(dir.path);
    }
    // print(dataBox.clear());
  }

  void getFiles(Directory dir) async {
    try {
      for (FileSystemEntity entity
          in (dir.listSync(recursive: false, followLinks: false))) {
        if (entity is File) {
          if (entity.path.endsWith('.mp3') ||
              entity.path.endsWith('.m4a') ||
              entity.path.endsWith('.wav')) {
            if (dataBox.isEmpty) {
              await generateHThumbnail(entity.path);
              // await generateThumbnail(entity.path);
              addSongToBox(entity.path);
            } else {
              if (dataBox.values
                  .where((element) => element.path == entity.path)
                  .isEmpty) {
                await generateHThumbnail(entity.path);
                // await generateThumbnail(entity.path);
                addSongToBox(entity.path);
              }
            }
          }
        }
        if (entity is Directory) {
          if (!isExcluded(entity.path)) {
            getFiles(entity);
          }
        }
      }
    } catch (e) {}
  }

  bool isExcluded(String p) {
    for (String s in excluded) {
      if (p.contains(s)) {
        return true;
      }
    }
    return false;
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
      fTitle: getfolder(File(path).parent.path),
      createdAt: await File(path).lastModified(),
      complete: map['title'] == "" ? true : false,
    );
    dataBox.add(data);
  }

  String getfolder(String s) {
    for (String k in storage) {
      if (s == k) {
        return s.split("/").last;
      } else if (s.contains(k)) {
        return s.split(k)[1].split('/').join(" • ");
      }
    }
    return "";
  }

  printHive() {
    List<DataModel> songs = dataBox.values.toList().cast<DataModel>();
    if (dataBox.isNotEmpty) {
      songs.sort((a, b) => a.title.compareTo(b.title));
      for (DataModel entity in songs) {
        print(" -->${entity.album} ${entity.title} \n");
      }
    }
  }

  generateHThumbnail(String path) async {
    final Uint8List bytes = await tagger.readArtwork(path: path);
    if (bytes != null) {
      Image image = decodeImage(bytes);
      Image thumbS = copyResize(image, width: 300);
      await thumb.put(path.hashCode, encodePng(thumbS));
    }
  }

  Future<void> fav() async {
    String path = player.sequence[player.currentIndex].tag.path;
    List f = favList.values.toList();
    if (!f.contains(path)) {
      await favList.add(path);
    } else {
      await favList.deleteAt(f.indexOf(path));
    }
  }

  printFav() {
    for (String s in favList.values.toList()) {
      print(s);
    }
  }

  Future<AudioDetails> getSongDetails(String path) async {
    final Map map = await tagger.readTagsAsMap(path: path);
    return AudioDetails(
      discNumber: map['discNumber'],
      discTotal: map['discTotal'],
      trackNo: map['trackNumber'],
      artist: map['artist'],
      album: map['album'],
      albumArtist: map['albumArtist'],
      genre: map['genre'],
      comment: map['comment'],
      title: map['title'],
      lyrics: map['lyrics'],
      year: map['year'],
    );
  }
}
