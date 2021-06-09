import 'package:hive/hive.dart';
import 'database_model.dart';
import 'find_songs.dart';

class SongDatabase {
  Box<Song> dataBox = Hive.box<Song>("songs_database");

  Future<void> updateDatabase() async {
    List<Song> data = dataBox.values.toList();
    final List<Song> songs = await FindSong().findSong();
    for (Song s in songs) {
      final Song song = Song(
        path: s.path,
        fileName: s.fileName,
        title: s.title,
        artist: s.artist,
        album: s.album,
        genre: s.genre,
        composer: s.composer,
        track: s.track,
        year: s.year,
      );
      if (data.where((element) => element.path == s.path).isEmpty) {
        print(song.path);
        await dataBox.add(song);
      }
    }
  }

  Future<void> forceUpdateDatabase() async {
    dataBox.clear();
    for (Song s in (await FindSong().findSong())) {
      print(s.path);
      await dataBox.add(Song(
        path: s.path,
        fileName: s.fileName,
        title: s.title,
        artist: s.artist,
        album: s.album,
        genre: s.genre,
        composer: s.composer,
        track: s.track,
        year: s.year,
      ));
    }
  }

  Future<List<Song>> fetchSong() async {
    List<Song> songs = dataBox.values.toList();
    return songs.length == 0 ? [] : songs;
  }
}
