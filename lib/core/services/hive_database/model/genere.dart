// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ruminate/core/services/hive_database/model/song.dart';

class Genere {
  final String name;
  final List<Song> songs;
  const Genere({required this.name, required this.songs});
}
