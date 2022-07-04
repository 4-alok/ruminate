import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:ruminate/core/services/hive_database/model/album.dart';
import 'package:ruminate/core/services/hive_database/model/artist.dart';
import 'package:ruminate/core/services/hive_database/model/genere.dart';
import 'package:ruminate/core/services/hive_database/model/song.dart';
import 'package:ruminate/core/services/music_player_service/audio_service/audio_service.dart';

import 'audio_service/desktop_audio_service.dart';
import 'repository/music_player_repository.dart';

@singleton
class MusicPlayerService implements MusicPlayerRepository {
  late final AudioService audioService;
  MusicPlayerService() {
    if (Platform.isLinux) {
      audioService = DesktopAudioService();
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  final isPlaying = ValueNotifier<bool>(false);

  @override
  void playAlbum(Album album, {bool shuffle = false, int index = 0}) {
    final songs = List<Song>.from(album.songs);
    shuffle ? songs.shuffle() : null;
    audioService.playPlaylist(songs, index);
  }

  @override
  void playAlbums(List<Album> albums) {
    List<Song> songs = [];
    for (Album album in albums) {
      songs.addAll(album.songs);
    }
    audioService.playPlaylist(songs);
  }

  @override
  void playArtist(Artist artist, {bool shuffle = false, int index = 0}) {
    final songs = List<Song>.from(artist.songs);
    shuffle ? songs.shuffle() : null;
    audioService.playPlaylist(songs, index);
  }

  @override
  void playArtists(List<Artist> artists, [int index = 0]) {
    List<Song> songs = [];
    for (Artist artist in artists) {
      songs.addAll(artist.songs);
    }
    audioService.playPlaylist(songs, index);
  }

  @override
  void playGenre(Genere genere, {bool shuffle = false, int index = 0}) {
    final songs = List<Song>.from(genere.songs);
    shuffle ? songs.shuffle() : null;
    audioService.playPlaylist(songs, index);
  }

  @override
  void playGenres(List<Genere> generes, [int index = 0]) {
    List<Song> songsList = [];
    for (Genere genere in generes) {
      songsList.addAll(genere.songs);
    }
    audioService.playPlaylist(songsList, index);
  }

  @override
  void playSongs(List<Song> songs, {bool shuffle = false, int index = 0}) =>
      audioService.playPlaylist(songs, index);

  @disposeMethod
  void dispose() async {
    audioService.dispose();
    isPlaying.dispose();
  }
}
