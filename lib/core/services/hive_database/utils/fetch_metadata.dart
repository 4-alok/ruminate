import 'dart:io';
import 'dart:isolate';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:ruminate/core/di/di.dart';

import '../model/song.dart';
import '../hive_database_impl.dart';


class FetchSongsMetadata {
  Isolate? _isolate;
  ReceivePort? _receivePort;

  Future<void> fetchToDatabase(List<String> list) async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_isolatedThread, [
      _receivePort!.sendPort,
      list,
    ]);
    
    final songBox = locator<HiveDatabase>().datasource.songBox;
    final thumbnailBox = locator<HiveDatabase>().datasource.thumbnailBox;

    _receivePort!.listen((data) async {
      if (data is List) {
        final song = data[0] as Song;
        await songBox.put(song.path, song);
        final art = data[1];
        if (art != null) await thumbnailBox.put(song.path, art);
      } else {
        _stop();
      }
    });
  }

  static void _isolatedThread(List objectList) async {
    final songList = objectList[1] as List<String>;
    await DartVLC.initialize();

    for (String songPaht in songList) {
      final metadataMap = Media.file(
        File(songPaht),
        parse: true,
      ).metas;

      final songMetadata = Song(
        path: songPaht,
        title: metadataMap['title'] ?? "",
        artist: metadataMap["artist"] ?? "",
        album: metadataMap["album"] ?? "<unknown-album>",
        genre: metadataMap["genre"] ?? "",
        composer: metadataMap['composer'] ?? "",
        track: metadataMap["track"] ?? "",
        year: metadataMap["year"] ?? "",
        duration: _duration(metadataMap["duration"]),
      );

      final artFile = File(_artPathPatch(metadataMap['artworkUrl']));

      (await artFile.exists())
          ? await artFile.readAsBytes().then((value) => objectList[0].send([
                songMetadata,
                value,
              ]))
          : objectList[0].send([
              songMetadata,
              null,
            ]);
    }
    objectList[0].send(null);
  }

  static String _artPathPatch(String? path) => (path == null || path == "")
      ? ""
      : "/${Uri.decodeFull(path).split('///').last}";

  static String _duration(String? songDuration) {
    if (songDuration == null) return "";
    final Duration duration = Duration(milliseconds: int.parse(songDuration));
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    final String twoDigitHour = twoDigits(duration.inHours);
    return (twoDigitHour == "00")
        ? "$twoDigitMinutes:$twoDigitSeconds"
        : "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _stop() {
    if (_isolate != null) {
      _receivePort!.close();
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }
}
