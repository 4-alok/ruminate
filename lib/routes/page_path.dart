// ignore_for_file: constant_identifier_names

part of 'app_router.dart';

abstract class Routes {
  Routes._();

  static const SONGS = _Path.SONGS;
  static const ALBUMS = _Path.ALBUMS;
  static const ARTISTS = _Path.ARTISTS;
  static const GENERES = _Path.GENERES;
  static const SETTINGS = _Path.SETTINGS;
  static const ALBUM_SONGS = _Path.ALBUM_SONGS;
  static const ARTIST_SONGS = _Path.ARTIST_SONGS;
  static const GENERE_SONGS = _Path.GENERE_SONGS;
}

abstract class _Path {
  static const String SONGS = '/student';
  static const String ALBUMS = '/albms';
  static const String ARTISTS = '/artists';
  static const String GENERES = '/generes';
  static const String SETTINGS = '/settings';
  static const String ALBUM_SONGS = '/album_songs';
  static const String ARTIST_SONGS = '/artist_songs';
  static const String GENERE_SONGS = '/genere_songs';
}
