import 'package:hive/hive.dart';
part 'database_model.g.dart';

@HiveType(typeId: 0)
class Song {
  @HiveField(0)
  final String path;
  @HiveField(1)
  final String fileName;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String artist;
  @HiveField(4)
  final String album;
  @HiveField(5)
  final String genre;
  @HiveField(6)
  final String composer;
  @HiveField(7)
  final String track;
  @HiveField(8)
  final String year;
  @HiveField(9)
  final String duration;
  @HiveField(10)
  Song(
      {required this.path,
      required this.fileName,
      required this.title,
      required this.artist,
      required this.album,
      required this.genre,
      required this.composer,
      required this.track,
      required this.year,
      required this.duration,
      });
}
