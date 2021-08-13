import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ruminate/app/utils/get_meta.dart';
import 'package:ruminate/app/utils/find_songs.dart';
import 'package:ruminate/app/utils/database_model.dart';
import 'package:ruminate/app/utils/storage_utils.dart';

List<Song> _sortSong(List<Song> newSongs) {
  newSongs
      .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
  return newSongs;
}

class SongDatabaseService extends GetxService {
  Box<Song> songBox = Hive.box<Song>("songs_database");

  final RxBool refreshing = false.obs;
  late final String thumbsPath;

  @override
  Future<void> onInit() async {
    super.onInit();
    thumbsPath = ((await StorageUtils.getDocDir()) + "/.thumbs");
  }

  Future<void> updateDatabase() async {
    refreshing.value = true;

    // find all songs
    final List<String> songs = await FindSong().findSong();

    // find songs that are in the database
    final List<String> storedSong =
        songBox.values.toList().map((e) => e.path).toList();

    // remove songs that are not in the database
    await _removeDeletedSong(
        storedSong.where((element) => songs.contains(element)).toList());

    // add newSongs to the database
    await _addNewSongs(
        songs.where((element) => !storedSong.contains(element)).toList());

    refreshing.value = false;
  }

  Future<void> _addNewSongs(List<String> _songs) async {
    final List<Song> newSongs = await VlcMeta().getSongsMetadata(_songs);

    // adding songs to the Hive database
    for (Song _song in await compute(_sortSong, newSongs)) {
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
    super.onClose();
  }

  Future<void> clearDatabase() async => await songBox.clear();
}
