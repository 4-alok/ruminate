import 'package:dart_vlc/dart_vlc.dart';

import '../../../../../core/di/di.dart';
import '../../../../../core/services/app_services/app_service.dart';
import '../../../../../core/services/hive_database/hive_database_impl.dart';
import '../../../../../core/services/hive_database/model/song.dart';
import '../../../../../core/services/music_player_service/music_player_service.dart';

mixin PanelUtils {
  MusicPlayerService get audioService => locator<MusicPlayerService>();
  AppService get appService => locator<AppService>();
  HiveDatabase get hiveDatabase => locator<HiveDatabase>();

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Song? getCurrentSong(CurrentState? state) {
    final playlist = state?.medias ?? [];
    if (playlist.isEmpty) return null;
    final index = (state?.index) ?? 0;
    return hiveDatabase.getSongsList
        .where((e) => e.path == playlist[index].resource)
        .first;
  }
}
