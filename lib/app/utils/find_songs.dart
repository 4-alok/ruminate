import 'dart:io';
import 'dart:isolate';

import 'package:get/get.dart';
import 'package:id3/id3.dart';
import 'package:path_provider/path_provider.dart';

class FindSong {
  Isolate? isolate;
  RxBool running = false.obs;
  ReceivePort? receivePort;
  static List<String> songs = [];

  void findSong() async {
    running.value = true;
    receivePort = ReceivePort();
    isolate = await Isolate.spawn(checkTimer, receivePort!.sendPort);
    receivePort!.listen((data) {
      stop();
    }, onDone: () {
      print("done!");
    });
  }

  static void checkTimer(SendPort sendPort) async {
    if (Platform.isLinux) {
      Directory dir = await getApplicationDocumentsDirectory();
      searchMp3(dir.parent);
    }
    print(songs.length);
    sendPort.send('msg');
  }

  static void searchMp3(Directory dir) async {
    for (FileSystemEntity e
        in dir.listSync(recursive: false, followLinks: false)) {
      if (e is File) {
        if (e.path.split('.').last.toLowerCase() == 'mp3') {
          print(e.path);
          songs.add(e.path);
        }
      } else if (e is Directory) {
        searchMp3(e);
      }
    }
  }

  void songdDetails() {
    String path = '/home/alok/Music/Punjabi/Hor Nai - Billy X.mp3';
    MP3Instance mp3instance = MP3Instance(path);
    print(mp3instance.parseTagsSync());
    if (mp3instance.parseTagsSync()) {
      print(mp3instance.getMetaTags());
      print(mp3instance.metaTags!['Title']);
      print(mp3instance.metaTags!['Artist']);
      print(mp3instance.metaTags!['Album']);
      print(mp3instance.metaTags!['Year']);
      print(mp3instance.metaTags!['Genre']);
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
