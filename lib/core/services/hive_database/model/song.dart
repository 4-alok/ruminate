import 'dart:convert';

class Song {
  final String path;
  final String title;
  final String artist;
  final String album;
  final String genre;
  final String composer;
  final String track;
  final String year;
  final String duration;
  const Song(
      {required this.path,
      required this.title,
      required this.artist,
      required this.album,
      required this.genre,
      required this.composer,
      required this.track,
      required this.year,
      required this.duration,});

  Map<String, dynamic> toMap() => <String, dynamic>{
        'path': path,
        'title': title,
        'artist': artist,
        'album': album,
        'genre': genre,
        'composer': composer,
        'track': track,
        'year': year,
        'duration': duration
      };

  factory Song.fromMap(Map<String, dynamic> map) => Song(
      path: map['path'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String,
      album: map['album'] as String,
      genre: map['genre'] as String,
      composer: map['composer'] as String,
      track: map['track'] as String,
      year: map['year'] as String,
      duration: map['duration'] as String);

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) =>
      Song.fromMap(json.decode(source) as Map<String, dynamic>);
}
