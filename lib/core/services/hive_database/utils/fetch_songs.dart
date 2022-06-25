import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:ruminate/core/utils/storge_utils.dart';

import '../../../../global/constant/exclude_dir.dart';

class FetchSongsPath {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  static List<String> songsPaths = [];

  Future<List<String>> get fetch async {
    _receivePort = ReceivePort();
    final storagePaths = await StorageUtils.getAvailableStorage()
        .then<Iterable<String>>((value) => value.map((e) => e.path));
    _isolate = await Isolate.spawn(
        _isolatedThread, [_receivePort!.sendPort, storagePaths]);

    final completer = Completer<List<String>>();
    _receivePort!.listen((data) => completer.complete(data));
    final res = await completer.future;
    _stop();
    return res;
  }

  static void _isolatedThread(List objectList) async {
    for (String path in (objectList[1] as Iterable<String>)) {
      await _searchMusicFiles(Directory(path));
    }
    objectList[0].send(songsPaths);
  }

  static Future<void> _searchMusicFiles(Directory dir) async {
    final list = await dir.list(recursive: false).toList();
    for (FileSystemEntity e in list) {
      if (e is File) {
        if (e.path.endsWith(".mp3")) songsPaths.add(e.path);
      } else if (e is Directory) {
        if (!_isExcludedDirectory(e.path)) await _searchMusicFiles(e);
      }
    }
  }

  static bool _isExcludedDirectory(String path) {
    if (Platform.isAndroid) {
      for (String p in ExcludeDir.excludeAndroidDir) {
        if (path.contains(p)) return true;
      }
    } else if (Platform.isLinux) {
      for (String p in ExcludeDir.excludeLinuxDir) {
        if (path.contains(p)) return true;
      }
    }
    return false;
  }

  void _stop() {
    if (_isolate != null) {
      _receivePort!.close();
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }
}
