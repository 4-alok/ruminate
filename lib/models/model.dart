import 'data_model.dart';

class AlbumModel {
  String albumName;
  List<DataModel> songs;

  AlbumModel({this.albumName, this.songs});
}

class FolderModel {
  String folder;
  String title;
  List<DataModel> songs;
  FolderModel({this.folder, this.title, this.songs});
}

class ArtistModel {
  String artist;
  List<DataModel> songs;

  ArtistModel({this.artist, this.songs});
}

class AudioMetadata {
  String path;
  String title;
  String artist;

  AudioMetadata({this.path, this.title, this.artist});
}

class AudioDetails {
  String discNumber;
  String discTotal;
  String trackNo;
  String artist;
  String album;
  String albumArtist;
  String genre;
  String comment;
  String title;
  String lyrics;
  String year;

  AudioDetails(
      {this.discNumber,
      this.discTotal,
      this.trackNo,
      this.artist,
      this.album,
      this.albumArtist,
      this.genre,
      this.comment,
      this.title,
      this.lyrics,
      this.year});
}
