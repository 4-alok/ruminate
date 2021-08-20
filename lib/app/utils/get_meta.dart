import 'dart:io';
import 'dart:async';
import 'dart:isolate';
import 'package:hive/hive.dart';
import 'package:ruminate/app/utils/storage_utils.dart';
import 'database_model.dart';
import 'package:dart_vlc/dart_vlc.dart';

class VlcMeta {
  Isolate? _isolate;
  ReceivePort? _receivePort;

  Future<List<Song>> getSongsMetadata(List<String> songsPath) async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(
      _isolatedThread,
      [_receivePort!.sendPort, songsPath, await StorageUtils.getDocDir()],
    );

    final Completer<List<Song>> completer = new Completer<List<Song>>();
    _receivePort!.listen((data) {
      completer.complete(data);
      stop();
    }, onDone: () {});
    return (await completer.future);
  }

  static void _isolatedThread(List r) async {
    Hive.init(r[2]);
    final String thumbDir = r[2] + "/.thumbs";

    DartVLC.initialize();

    List<Song> songs = [];

    if (!(await Directory(thumbDir).exists())) {
      await Directory(thumbDir).create();
    }

    for (int i = 0; i < r[1].length; i++) {
      final String path = r[1][i].toString();

      // Meta map
      final Map<String, dynamic> data =
          Media.file(File(path), parse: true).metas;

      // copy art from vlc cache to ruminate cache folder
      final String _path = _pathPatch(data['artworkUrl']);
      final thumbnailPath =
          thumbDir + "/" + r[1][i].toString().hashCode.toString();
      try {
        if (_path != '/') await File(_path).copy(thumbnailPath);
      } catch (e) {
        print(e);
      }

      songs.add(
        Song(
          path: r[1][i].toString(),
          fileName: path.split("/").last.split(".").first,
          title: data["title"] ?? "",
          artist: data["artist"] ?? "",
          album: data["album"] ?? "",
          genre: data["genre"] ?? "",
          composer: data['composer'] ?? "",
          track: data["track"] ?? "",
          year: data["year"] ?? "",
          duration: _duration(data["duration"]),
          artPath: (_path == '/') ? "" : thumbnailPath,
        ),
      );
    }
    r[0].send(songs);
  }

  static String _duration(String? duration) {
    if (duration == null) return "";
    final Duration _duration = Duration(milliseconds: int.parse(duration));
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final String twoDigitMinutes = twoDigits(_duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(_duration.inSeconds.remainder(60));
    final String twoDigitHour = twoDigits(_duration.inHours);
    return (twoDigitHour == "00")
        ? "$twoDigitMinutes:$twoDigitSeconds"
        : "${twoDigits(_duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static String _pathPatch(String path) {
    String _path = '/' +
        path
            .split('///')
            .last
            .replaceAll("%20", " ")
            .replaceAll("%21", "!")
            .replaceAll("%22", '"')
            .replaceAll("%23", "#")
            .replaceAll("%24", "\$")
            .replaceAll("%25", "%")
            .replaceAll("%26", "&")
            .replaceAll("%27", "'")
            .replaceAll("%28", "(")
            .replaceAll("%29", ")")
            .replaceAll("%2A", "*")
            .replaceAll("%2B", "+")
            .replaceAll("%2C", ",")
            .replaceAll("%2D", "-")
            .replaceAll("%2E", ".")
            .replaceAll("%2F", "/")
            .replaceAll("%3A", ":")
            .replaceAll("%3B", ";")
            .replaceAll("%3C", "<")
            .replaceAll("%3D", "=")
            .replaceAll("%3E", ">")
            .replaceAll("%3F", "?")
            .replaceAll("%40", "@")
            .replaceAll("%5B", "[")
            .replaceAll("%5C", "\\")
            .replaceAll("%5D", "]")
            .replaceAll("%5E", "^")
            .replaceAll("%5F", "_")
            .replaceAll("%60", "`");
    return _path;
  }

  void stop() {
    if (_isolate != null) {
      _receivePort!.close();
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }
}
