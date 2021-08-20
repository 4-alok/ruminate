import 'package:ruminate/app/utils/database_model.dart';

class Album {
  final String albumName;
  final String artPath;
  List<Song> songs;
  Album({
    required this.albumName,
    required this.artPath,
    required this.songs,
  });
}
