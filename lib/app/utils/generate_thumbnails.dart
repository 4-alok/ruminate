import 'dart:io';
import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:image/image.dart' as Img;
import 'package:ruminate/app/global/models/album.dart';
import 'package:ruminate/app/utils/database_model.dart';

class GenerateThumbnails {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  static Map<int, List<int>> imageMap = {};

  Future<Map<int, List<int>>> task(List<Song> songs) async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(
        _generateThumbnailsTask, [_receivePort!.sendPort, songs]);

    final completer = new Completer<Map<int, List<int>>>();

    _receivePort!.listen((data) {
      completer.complete(data);
      stop();
    });
    return (await completer.future);
  }

  static void _generateThumbnailsTask(List r) async {
    final songs = r[1] as List<Song>;
    for (Song song in songs) {
      if (song.artPath != null || song.artPath != "") {
        try {
          final data = await File(song.artPath!).readAsBytes();
          final Img.Image thumbnail =
              Img.copyResize(Img.decodeImage(data)!, width: 250);

          imageMap.addAll({song.artPath.hashCode: Img.encodePng(thumbnail)});
        } catch (e) {
          print(e);
        }
      }
    }
    r[0].send(imageMap);
  }

  void stop() {
    if (_isolate != null) {
      _receivePort!.close();
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }

  static void generateThumbnails(List<Song> songs) async {
    final Box thumbnails = Hive.box("thumbnails");

    final data = await GenerateThumbnails().task(songs);
    await thumbnails.putAll(data);
    print("done");
  }

  void length() async {
    final Box thumbnails = Hive.box("thumbnails");
    print(thumbnails.length);
  }

  void clear() async {
    final Box thumbnails = Hive.box("thumbnails");
    await thumbnails.clear();
  }

  void test(List<Album> albums) async {
    final Box thumbnails = Hive.box("thumbnails");

    for (Album album in albums) {
      final data = thumbnails.get(album.artPath.hashCode) as Uint8List?;
      if (data != null) {
        print(album.albumName);
      }
    }
  }
}
