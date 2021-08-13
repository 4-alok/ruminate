import 'dart:io';
import 'dart:async';
import 'dart:isolate';
import 'package:ruminate/app/utils/storage_utils.dart';
import 'package:ruminate/app/global/constant/constant.dart';

class FindSong {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  static List<String> _songs = [];

  Future<List<String>> findSong() async {
    _receivePort = ReceivePort();
    final List<String> _storage =
        (await StorageUtils.getAvailableStorage()).map((e) => e.path).toList();
    _isolate = await Isolate.spawn(
        _isolatedThread, [_receivePort!.sendPort, _storage]);

    final Completer<List<String>> completer = new Completer<List<String>>();
    _receivePort!.listen((data) {
      completer.complete(data);
      stop();
    }, onDone: () {});
    return (await completer.future);
  }

  static void _isolatedThread(List r) async {
    r[1].forEach((e) => _searchMp3(Directory(e)));
    r[0].send(_songs);
  }

  static void _searchMp3(Directory dir) async {
    final List<FileSystemEntity> list =
        dir.listSync(recursive: false, followLinks: false);
    for (FileSystemEntity e in list) {
      if (e is File) {
        if (e.path.endsWith(".mp3")) {
          _songs.add(e.path);
        }
      } else if (e is Directory) {
        if (!_isExcludedDirectory(e.path)) _searchMp3(e);
      }
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
