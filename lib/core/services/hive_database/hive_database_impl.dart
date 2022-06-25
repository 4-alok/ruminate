import 'dart:typed_data';

import 'package:ruminate/core/services/hive_database/model/album.dart';
import 'package:ruminate/core/services/hive_database/model/artist.dart';
import 'package:ruminate/core/services/hive_database/model/favourite.dart';
import 'package:ruminate/core/services/hive_database/model/genere.dart';
import 'package:ruminate/core/services/hive_database/model/song.dart';

import 'datasource/hive_datasource.dart';
import 'utils/sort_song.dart';
import 'repository/hive_database_repository.dart';

class HiveDatabase extends SortSongs implements HiveDatabaseRepository {
  final HiveDatasource datasource = HiveDatasource();

  @override
  Future<void> get clearDatabase async => await datasource.clearDatabase;

  @override
  List<Song> get getSongsList => datasource.getSongsList;

  @override
  Future<List<Album>> get getAlbumsList async => await getAlbum(getSongsList);

  @override
  Future<Uint8List> getArt(String path) async => datasource.getArt(path);

  @override
  Future<List<Artist>> get getArtistsList async =>
      await getArtist(getSongsList);

  @override
  // TODO: Implement getFavSongsList
  Future<List<Favourite>> get getFavSongsList => throw UnimplementedError();

  @override
  Future<List<Genere>> get getGenresList async => await getGeneres(getSongsList); 

  @override
  Future<void> get updateDatabase async => await datasource.updateDatabase;
}
