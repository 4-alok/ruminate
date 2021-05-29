import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:get/get.dart';
import 'package:id3/id3.dart';
import 'package:path_provider/path_provider.dart';

import 'database_model.dart';

class FindSong {
  Isolate? isolate;
  RxBool running = false.obs;
  ReceivePort? receivePort;
  static List<Song> songs = [];

  Future<List<Song>> findSong() async {
    running.value = true;
    receivePort = ReceivePort();
    isolate = await Isolate.spawn(checkTimer, receivePort!.sendPort);
    final Completer<List<Song>> completer = new Completer<List<Song>>();
    receivePort!.listen((data) {
      completer.complete(data);
      stop();
    }, onDone: () {});
    return completer.future;
  }

  static void checkTimer(SendPort sendPort) async {
    if (Platform.isLinux) {
      Directory dir = await getApplicationDocumentsDirectory();
      searchMp3(dir.parent);
    }
    sendPort.send(songs);
  }

  static void searchMp3(Directory dir) async {
    for (FileSystemEntity e
        in dir.listSync(recursive: false, followLinks: false)) {
      if (e is File) {
        if (e.path.split('.').last.toLowerCase() == 'mp3') {
          songdDetails(e.path);
        }
      } else if (e is Directory) {
        searchMp3(e);
      }
    }
  }

  static void songdDetails(String path) {
    MP3Instance mp3instance = MP3Instance(path);
    try {
      if (mp3instance.parseTagsSync()) {
        songs.add(
          Song(
              path: path,
              fileName: path.split('/').last.split('.').first,
              title: mp3instance.metaTags!['Title'],
              artist: mp3instance.metaTags!['Artist'],
              album: mp3instance.metaTags!['Album'],
              genre: mp3instance.metaTags!['Genre'],
              composer: mp3instance.metaTags!['Composer'],
              track: mp3instance.metaTags!['Track'],
              year: mp3instance.metaTags!['Year']),
        );
      }
    } catch (e) {
      songs.add(
        Song(
            path: path,
            fileName: path.split('/').last.split('.').first,
            title: path.split('/').last.split('.').first,
            artist: '',
            album: '',
            genre: '',
            composer: '',
            track: '',
            year: ''),
      );
    }
  }

  void stop() {
    if (isolate != null) {
      receivePort!.close();
      isolate!.kill(priority: Isolate.immediate);
      isolate = null;
    }
  }
}
