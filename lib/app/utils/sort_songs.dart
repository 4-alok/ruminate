//This sorts the songs
import 'package:flutter/foundation.dart';
import 'package:ruminate/app/global/models/album.dart';
import 'package:ruminate/app/utils/database_model.dart';

List<Album> _getAlbum(List<Song> songs) {
  List<Album> albums = [];

  for (Song song in songs) {
    if (albums.where((element) => element.albumName == song.album).isEmpty) {
      albums.add(Album(
          albumName: song.album, artPath: song.artPath ?? "", songs: [song]));
    } else {
      final int index =
          albums.indexWhere((element) => element.albumName == song.album);
      albums[index].songs.add(song);
    }
  }
  return albums;
}

class SongSort {
  static Future<List<Album>> getAlbum(List<Song> songs) async {
    return await compute(_getAlbum, songs);
  }
}
