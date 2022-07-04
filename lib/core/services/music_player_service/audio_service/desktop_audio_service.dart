import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:ruminate/core/di/di.dart';
import 'package:ruminate/core/services/app_services/app_service.dart';
import 'package:ruminate/core/services/music_player_service/audio_service/audio_service.dart';

import '../../hive_database/model/song.dart';

// ignore: constant_identifier_names
const ID = 04052000;

class DesktopAudioService extends AudioService {
  late final Player player;
  DesktopAudioService() {
    player = Player(
      id: ID,
      commandlineArguments: ['--no-video'],
    );
    player.playbackStream.listen((playbackStream) {
      if (playbackStream.isPlaying) {
        locator<AppService>().panelController.show();
      }
    });
  }

  @override
  Player get getPlayer => player;

  @override
  void playPlaylist(List<Song> songs, [int index = 0]) {
    final playlist = Playlist(
      medias: songs.map<Media>((e) => Media.file(File(e.path))).toList(),
    );
    player.open(playlist);
    player.jumpToIndex(index);
  }

  @override
  void next() => player.next();

  @override
  void pause() => player.pause();

  @override
  void play() => player.play();

  @override
  void previous() => player.previous();

  @override
  void seek(Duration duration) => player.seek(duration);

  @override
  void setVolume(double value) => player.setVolume(value);

  @override
  void stop() => player.stop();

  @override
  void dispose() {
    player.dispose();
    throw UnimplementedError();
  }
}
