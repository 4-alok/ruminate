import '../../hive_database/model/song.dart';

abstract class MusicPlayerControllerRepository {
  void addToQueue(List<Song> songs);
  void pause();
  void stop();
  void next();
  void previous();
  void seek(double value);
  void setVolume(double value);
}
