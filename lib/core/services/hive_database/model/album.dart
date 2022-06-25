import 'package:ruminate/core/services/hive_database/model/song.dart';

class Album {
  final String albumName;
  final String artPath;
  final List<Song> songs;
  const Album(
      {required this.albumName, required this.artPath, required this.songs});
}
