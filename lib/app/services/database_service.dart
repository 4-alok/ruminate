import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ruminate/app/utils/database_model.dart';
import 'package:ruminate/app/utils/find_songs.dart';
import 'package:ruminate/app/utils/get_meta.dart';

class SongDatabaseService extends GetxService {
  Box<Song> songBox = Hive.box<Song>("songs_database");
  late final LazyBox<dynamic> thumbnailsBox;

  final RxBool thumbnailsReady = false.obs;
  final RxBool refreshing = false.obs;

  @override
  void onInit() {
    initThumbnail();
    super.onInit();
  }

  void initThumbnail() async {
    thumbnailsBox = await Hive.openLazyBox('thumbnails');
    thumbnailsReady.value = true;
  }

  Future<void> updateDatabase() async {
    refreshing.value = true;
    final List<String> songs = await FindSong().findSong();
    final List<String> storedSong =
        songBox.values.toList().map((e) => e.path).toList();

    await _removeDeletedSong(
        storedSong.where((element) => songs.contains(element)).toList());

    await _addNewSongs(
        songs.where((element) => !storedSong.contains(element)).toList());

    refreshing.value = false;
  }

  Future<void> _addNewSongs(List<String> _songs) async {
    print(_songs.length);
    final List<Song> newSongs = await VlcMeta().getSongsMetadata(_songs);
    newSongs
        .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    for (Song _song in newSongs) {
      await songBox.add(_song);
    }
  }

  Future<void> _removeDeletedSong(List<String> _songs) async {
    final List<Song> k = songBox.values.toList();
    for (String _song in _songs) {
      await songBox.deleteAt(k.indexWhere((element) => element.path == _song));
    }
  }

  @override
  onClose() {
    songBox.close();
    thumbnailsBox.close();
    super.onClose();
  }

  Future<void> clearDatabase() async => await songBox.clear();
}
