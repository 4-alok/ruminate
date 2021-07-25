import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ruminate/app/utils/database_model.dart';
import 'package:ruminate/app/utils/find_songs.dart';

class SongDatabaseService extends GetxService {
  Box<Song> songBox = Hive.box<Song>("songs_database");
  late final LazyBox<dynamic> thumbnailsBox;

  RxBool thumbnailsReady = false.obs;

  @override
  void onInit() {
    initThumbnail();
    super.onInit();
  }

  void initThumbnail() async {
    thumbnailsBox = await Hive.openLazyBox('thumbnails');
    thumbnailsReady.value = true;
  }

  @override
  onClose() {
    songBox.close();
    thumbnailsBox.close();
    super.onClose();
  }

  Future<void> updateDatabase() async {
    final List<Song> data = songBox.values.toList();
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
        await songBox.add(song);
      }
    }
  }

  Future<void> clearDatabase() async => await songBox.clear();

  Future<void> forceUpdateDatabase() async {
    songBox.clear();
    for (Song s in (await FindSong().findSong())) {
      print(s.path);
      await songBox.add(Song(
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
    List<Song> songs = songBox.values.toList();
    return songs.length == 0 ? [] : songs;
  }
}
