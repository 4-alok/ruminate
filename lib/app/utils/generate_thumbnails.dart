import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:id3/id3.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'database_model.dart';

class GenerateThumbnails {
  Isolate? isolate;
  bool running = false;
  ReceivePort? receivePort;

  Future<void> generateThumbnails() async {
    running = true;
    receivePort = ReceivePort();
    isolate = await Isolate.spawn(isolatedThread, receivePort!.sendPort);
    receivePort!.listen((data) {
      stop();
    }, onDone: () {});
  }

  static void isolatedThread(SendPort sendPort) async {
    Hive.init((await getApplicationDocumentsDirectory()).path);
    Hive.registerAdapter<Song>(SongAdapter());
    Box<Song> songs = await Hive.openBox('songs_database');
    LazyBox<dynamic> thumbnails = await Hive.openLazyBox('thumbnails');
    for (Song song in songs.values) {
      if ((await thumbnails.get(song.path.hashCode)) == null) {
        final Uint8List? image = await getArt(song.path);
        try {
          final Image thumbnail = copyResize(decodeImage(image!)!, width: 250);
          await thumbnails.put(song.path.hashCode, encodePng(thumbnail));
          print('added ${song.title}');
        } catch (e) {
          await thumbnails.put(song.path.hashCode, null);
          print('!!! added ${song.title}');
        }
      } else {
        print("Already added ${song.title}");
      }
    }
    sendPort.send('');
  }

  static Future<Uint8List?> getArt(String path) async {
    MP3Instance mp3instance = MP3Instance(path);
    try {
      if (mp3instance.parseTagsSync()) {
        return base64Decode(mp3instance.metaTags!['APIC']['base64']);
      }
    } catch (e) {}
    return null;
  }

  void stop() {
    if (isolate != null) {
      receivePort!.close();
      isolate!.kill(priority: Isolate.immediate);
      isolate = null;
    }
  }
}
