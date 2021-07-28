import 'dart:io';

import 'package:get/get.dart';

import 'desktop_audio_services.dart';

class PlayerController extends GetxService {
  final RxBool isPlaying = false.obs;
  final DesktopAudioService desktopAudioService =
      Get.find<DesktopAudioService>();

  void play() {}

  void playSingleAudio(String path) {
    if (!isPlaying.value) {
      if (Platform.isLinux || Platform.isWindows) {
        desktopAudioService.playSingleAudio(path);
        isPlaying.value = true;
      }
    }
  }

  void stop() {
    if (isPlaying.value) {
      if (Platform.isLinux || Platform.isWindows) {
        desktopAudioService.stopPlayer();
        isPlaying.value = false;
      }
    }
  }

  void pause() {
    if (isPlaying.value) {
      if (Platform.isLinux || Platform.isWindows) {
        desktopAudioService.pause();
        isPlaying.value = false;
      }
    }
  }

  void resume() {
    if (isPlaying.value) {
      if (Platform.isLinux || Platform.isWindows) {
        desktopAudioService.resume();
        isPlaying.value = true;
      }
    }
  }
}
