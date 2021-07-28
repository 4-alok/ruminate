import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:get/get.dart';
import 'package:id3/id3.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ruminate/app/global/constant/constant.dart';
import 'database_model.dart';

class FindSong {
  Isolate? _isolate;
  RxBool running = false.obs;
  ReceivePort? _receivePort;
  static List<Song> _songs = [];
  List<Directory> _storage = [];

  Future<List<Song>> findSong() async {
    running.value = true;
    _receivePort = ReceivePort();
    await _setStorage();

    _storage.forEach((e) => print(e));

    _isolate = await Isolate.spawn(
        _isolatedThread, [_receivePort!.sendPort, _storage]);

    final Completer<List<Song>> completer = new Completer<List<Song>>();
    _receivePort!.listen((data) {
      completer.complete(data);
      stop();
    }, onDone: () {});
    List<Song> data = await completer.future;
    data.sort((a, b) => a.title.compareTo(b.title));
    return data;
  }

  static void _isolatedThread(List r) async {
    r[1].forEach((e) => _searchMp3(e));
    r[0].send(_songs);
  }

  Future<void> _setStorage() async {
    if (Platform.isLinux) {
      Directory dir = await getApplicationDocumentsDirectory();
      _storage = [dir.parent];
    } else if (Platform.isAndroid) {
      _storage = await _getAndroidStorageList();
    }
  }

  Future<List<Directory>> _getAndroidStorageList() async {
    List<Directory> storages =
        (await getExternalStorageDirectories()) ?? [Directory("")];

    storages = storages.map((Directory e) {
      final List<String> splitedPath = e.path.split("/");
      return Directory(splitedPath
          .sublist(0, splitedPath.indexWhere((element) => element == "Android"))
          .join("/"));
    }).toList();
    return storages;
  }

  static void _searchMp3(Directory dir) async {
    print(dir.path);
    try {
      List<FileSystemEntity> list =
          dir.listSync(recursive: false, followLinks: false);
      for (FileSystemEntity e in list) {
        if (e is File) {
          if (e.path.split('.').last.toLowerCase() == 'mp3') {
            _songdDetails(e.path);
          }
        } else if (e is Directory) {
          if (!_isExcludedDirectory(e.path)) _searchMp3(e);
        }
      }
    } catch (e) {}
  }

  static void _songdDetails(String path) {
    final List<int> mp3Bytes = File(path).readAsBytesSync();
    final MP3Instance mp3instance = new MP3Instance(mp3Bytes);
    try {
      if (mp3instance.parseTagsSync()) {
        _songs.add(
          Song(
              path: path,
              fileName: path.split('/').last.split('.').first,
              title: mp3instance.metaTags['Title'],
              artist: mp3instance.metaTags['Artist'],
              album: mp3instance.metaTags['Album'],
              genre: mp3instance.metaTags['Genre'],
              composer: mp3instance.metaTags['Composer'],
              track: mp3instance.metaTags['Track'],
              year: mp3instance.metaTags['Year']),
        );
      }
    } catch (e) {
      _songs.add(
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
    if (_isolate != null) {
      _receivePort!.close();
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }

  static bool _isExcludedDirectory(String path) {
    if (Platform.isAndroid) {
      for (String p in Constant.excludeAndroidDir) {
        if (path.contains(p)) return true;
      }
    } else if (Platform.isLinux) {
      for (String p in Constant.excludeLinuxDir) {
        if (path.contains(p)) return true;
      }
    }
    return false;
  }
}
