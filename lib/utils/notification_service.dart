import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'audio_service.dart';

class NotificationServices {
  init() async {
    MediaNotification.showNotification();

    MediaNotification.setListener('next', () {
      player.seekToNext();
    });
    MediaNotification.setListener('prev', () {
      player.seekToPrevious();
    });
    MediaNotification.setListener('pause', () {
      player.pause();
    });

    MediaNotification.setListener('play', () {
      player.play();
    });
  }

  void isPlaying(bool playing) async {
    if (player.currentIndex != null) {
      init();
      await MediaNotification.showNotification(
          isPlaying: playing,
          title: player.sequence[player.currentIndex].tag.title,
          author: player.sequence[player.currentIndex].tag.artist);
    } else {
      MediaNotification.hideNotification();
    }
  }

  void updateNotificationContent(int i) async {
    if (i != null) {
      init();
      await MediaNotification.showNotification(
          isPlaying: player.playing,
          title: player.sequence[i].tag.title,
          author: player.sequence[i].tag.artist);
    } else {
      MediaNotification.hideNotification();
    }
  }

  disposeNotification() {
    MediaNotification.hideNotification();
  }
}
