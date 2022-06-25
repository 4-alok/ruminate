import 'dart:typed_data';

import '../model/song.dart';

abstract class HiveDatasourceRepository {
  Future<void> get initDatabase;
  Future<void> get updateDatabase;
  Future<void> get clearDatabase;
  Future<void> get closeDatabase;
  List<Song> get getSongsList;
  Future<Uint8List> getArt(String path);
}
