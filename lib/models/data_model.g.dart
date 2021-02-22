part of 'data_model.dart';

class DataModelAdapter extends TypeAdapter<DataModel> {
  @override
  final int typeId = 0;

  @override
  DataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataModel(
      path: fields[0] as String,
      title: fields[1] as String,
      artist: fields[2] as String,
      album: fields[3] as String,
      albumArtist: fields[4] as String,
      year: fields[5] as String,
      folder: fields[6] as String,
      fTitle: fields[7] as String,
      createdAt: fields[8] as DateTime,
      duration: fields[9] as String,
      playCount: fields[10] as int,
      complete: fields[11] as bool,
      fav: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DataModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.album)
      ..writeByte(4)
      ..write(obj.albumArtist)
      ..writeByte(5)
      ..write(obj.year)
      ..writeByte(6)
      ..write(obj.folder)
      ..writeByte(7)
      ..write(obj.fTitle)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.duration)
      ..writeByte(10)
      ..write(obj.playCount)
      ..writeByte(11)
      ..write(obj.complete)
      ..writeByte(12)
      ..write(obj.fav);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
