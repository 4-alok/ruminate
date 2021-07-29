import 'dart:io';
import 'dart:async';
import 'dart:isolate';
import 'database_model.dart';
import 'package:dart_vlc/dart_vlc.dart';

class VlcMeta {
  Isolate? _isolate;
  ReceivePort? _receivePort;

  Future<List<Song>> getSongsMetadata(List<String> songsPath) async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(
        _isolatedThread, [_receivePort!.sendPort, songsPath]);

    final Completer<List<Song>> completer = new Completer<List<Song>>();
    _receivePort!.listen((data) {
      completer.complete(data);
      stop();
    }, onDone: () {
    });
    return (await completer.future);
  }

  static void _isolatedThread(List r) async {
    DartVLC.initialize();
    r[0].send(List.generate(r[1].length, (index) {
      final Map<String, dynamic> data =
          Media.file(File(r[1][index]), parse: true).metas;
      return Song(
        path: r[1][index].toString(),
        fileName: r[1][index].toString().split("/").last.split(".").first,
        title: data["title"] ?? "",
        artist: data["artist"] ?? "",
        album: data["album"] ?? "",
        genre: data["genre"] ?? "",
        composer: data['composer'] ?? "",
        track: data["track"] ?? "",
        year: data["year"] ?? "",
        duration: data["duration"] ?? "",
      );
    }));
  }

  void stop() {
    if (_isolate != null) {
      _receivePort!.close();
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }
}
