import 'package:hive_flutter/adapters.dart';

import '../services/hive_database/model/song.dart';

class SongAdapter extends TypeAdapter<Song> {
  @override
  final int typeId = 0;

  @override
  Song read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Song(
      album: fields[0] as String,
      artist: fields[1] as String,
      composer: fields[2] as String,
      duration: fields[3] as String,
      genre: fields[4] as String,
      path: fields[5] as String,
      title: fields[6] as String,
      track: fields[7] as String,
      year: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Song obj) => writer
    ..writeByte(9)
    ..writeByte(0)
    ..write(obj.album)
    ..writeByte(1)
    ..write(obj.artist)
    ..writeByte(2)
    ..write(obj.composer)
    ..writeByte(3)
    ..write(obj.duration)
    ..writeByte(4)
    ..write(obj.genre)
    ..writeByte(5)
    ..write(obj.path)
    ..writeByte(6)
    ..write(obj.title)
    ..writeByte(7)
    ..write(obj.track)
    ..writeByte(8)
    ..write(obj.year);
}
