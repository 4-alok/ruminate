import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../model/song.dart';
import '../utils/fetch_metadata.dart';
import '../utils/fetch_songs.dart';
import 'hive_datasource_repository.dart';

class HiveDatasource implements HiveDatasourceRepository {
  late final LazyBox thumbnailBox;
  late final Uint8List imgThumbnail;
  late final Box<Song> songBox;

  @override
  Future<void> get initDatabase async {
    songBox = await Hive.openBox<Song>("songs_database");
    thumbnailBox = await Hive.openLazyBox("thumbnails_database");
    imgThumbnail = await rootBundle
        .load(r"assets/icon.png")
        .then<Uint8List>((value) => value.buffer.asUint8List());
  }

  @override
  Future<void> get updateDatabase async {
    // find all songs path [List<String>] from available storage [String]
    final songsPathFetched = await FetchSongsPath().fetch;

    // Songs[String] stored in Hive Database
    final storedSong = songBox.values.map((e) => e.path);

    // Remove the songs form database if file dosen't exist
    await _removeDeletedSongs(
      storedSong.where((element) => !songsPathFetched.contains(element)),
    );

    // Add new songs to the database if data is not stored in database
    await _addNewSongs(
      songsPathFetched.where((element) => !storedSong.contains(element)),
    );
  }

  Future<void> _addNewSongs(Iterable<String> allSongs) async =>
      await FetchSongsMetadata().fetchToDatabase(allSongs.toList());

  Future<void> _removeDeletedSongs(Iterable<String> allSongs) async {
    await songBox.deleteAll(allSongs);
    await thumbnailBox.deleteAll(allSongs);
  }

  @override
  List<Song> get getSongsList => songBox.values.toList();

  @override
  Future<Uint8List> getArt(String path) async => (await thumbnailBox.get(
        path,
        defaultValue: imgThumbnail,
      )) as Uint8List;

  @override
  Future<void> get closeDatabase async => await Hive.close();

  @override
  Future<void> get clearDatabase async {
    await songBox.clear();
    await thumbnailBox.clear();
  }
}
