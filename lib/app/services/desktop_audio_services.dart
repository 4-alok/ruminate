import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:get/get.dart';

class DesktopAudioService extends GetxService {
  final Player _player = Player(id: 69420);

  void playSingleAudio(String path) {
    _player.open(
      Media.file(File(path)),
      autoStart: true, // default
    );
  }

  void stopPlayer() => _player.stop();

  void pause() => _player.pause();

  void resume() => _player.play();
}
