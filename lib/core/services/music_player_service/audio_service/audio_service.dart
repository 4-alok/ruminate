import 'package:dart_vlc/dart_vlc.dart';
import 'package:ruminate/core/services/hive_database/model/song.dart';

abstract class AudioService {
  Player get getPlayer;
  void playPlaylist(List<Song> songs, [int index = 0]);
  void next();
  void pause();
  void play();
  void previous();
  void seek(Duration duration);
  void setVolume(double value);
  void stop();
  void dispose();
}
