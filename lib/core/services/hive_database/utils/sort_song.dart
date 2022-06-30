import 'package:flutter/foundation.dart';
import 'package:ruminate/core/di/di.dart';
import 'package:ruminate/core/services/hive_database/model/artist.dart';
import 'package:ruminate/core/services/hive_database/model/genere.dart';

import '../model/album.dart';
import '../model/song.dart';
import '../hive_database_impl.dart';

List<Genere> _getGeneres(List<Song> songs) {
  final List<Genere> generes = <Genere>[];
  for (Song song in songs) {
    if (generes.where((element) => element.name == song.genre).isEmpty) {
      generes.add(Genere(name: song.genre, songs: [song]));
    } else {
      generes[generes.indexWhere((element) => element.name == song.genre)]
          .songs
          .add(song);
    }
  }
  generes.sort((a, b) => a.name.compareTo(b.name));
  for (Genere genere in generes) {
    genere.songs.sort((a, b) => a.title.compareTo(b.title));
  }
  return generes;
}

List<Album> _getAlbum(List<Song> songs) {
  List<Album> albums = [];
  for (Song song in songs) {
    if (albums.where((element) => element.albumName == song.album).isEmpty) {
      albums
          .add(Album(albumName: song.album, artPath: song.path, songs: [song]));
    } else {
      albums[albums.indexWhere((element) => element.albumName == song.album)]
          .songs
          .add(song);
    }
  }
  albums.sort((a, b) => a.albumName
      .toLowerCase()
      .trim()
      .compareTo(b.albumName.toLowerCase().trim()));
  for (Album album in albums) {
    album.songs.sort((a, b) => a.title.compareTo(b.title));
  }
  return albums;
}

List<Artist> _getArtist(List<Song> songs) {
  List<Artist> artists = [];
  for (Song song in songs) {
    if (artists.where((element) => element.artistName == song.artist).isEmpty) {
      artists.add(Artist(artistName: song.artist, songs: [song]));
    } else {
      artists[artists
              .indexWhere((element) => element.artistName == song.artist)]
          .songs
          .add(song);
    }
  }
  artists.sort((a, b) => a.artistName
      .toLowerCase()
      .trim()
      .compareTo(b.artistName.toLowerCase().trim()));
  for (Artist artist in artists) {
    artist.songs.sort((a, b) => a.title.compareTo(b.title));
  }
  return artists;
}

abstract class SortSongs {
  Future<List<Album>> getAlbum(List<Song> songsList) async =>
      await compute(_getAlbum, songsList);

  Future<List<Artist>> getArtist(List<Song> songsList) async =>
      await compute(_getArtist, songsList);

  Future<List<Genere>> getGeneres(List<Song> songsList) async =>
      await compute(_getGeneres, songsList);
}

class SortSongsO {
  static Future<List<Album>> getAlbum([List<Song>? songsList]) async {
    final songs = songsList ?? locator<HiveDatabase>().getSongsList;
    return await compute(_getAlbum, songs);
  }
}
