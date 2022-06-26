import 'dart:typed_data';

import '../model/album.dart';
import '../model/artist.dart';
import '../model/favourite.dart';
import '../model/genere.dart';
import '../model/song.dart';

abstract class HiveDatabaseRepository {
  Future<void> get updateDatabase;
  Future<void> get clearDatabase;
  List<Song> get getSongsList;
  Future<List<Album>> get getAlbumsList;
  Future<List<Artist>> get getArtistsList;
  Future<List<Genere>> get getGenresList;
  Future<List<Favourite>> get getFavSongsList;
  Future<void> get closeDatabase;

  Future<Uint8List> getArt(String path);
}
