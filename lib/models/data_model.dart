import 'package:hive/hive.dart';
part 'data_model.g.dart';

@HiveType(typeId: 0)
class DataModel {
  @HiveField(0)
  final String path;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String artist;
  @HiveField(3)
  final String album;
  @HiveField(4)
  final String albumArtist;
  @HiveField(5)
  final String year;
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final String duration;
  @HiveField(8)
  final int playCount;
  @HiveField(9)
  final bool complete;

  DataModel(
      {this.path,
      this.title,
      this.artist,
      this.album,
      this.albumArtist,
      this.year,
      this.createdAt,
      this.duration,
      this.playCount,
      this.complete});
}
