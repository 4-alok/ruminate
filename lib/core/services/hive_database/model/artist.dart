// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ruminate/core/services/hive_database/model/song.dart';

class Artist {
  final String artistName;
  final List<Song> songs;
  Artist({required this.artistName, required this.songs});
}
