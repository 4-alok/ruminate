import 'package:Ruminate/models/data_model.dart';
import 'package:Ruminate/models/model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

AudioPlayer player;

enum Sorting {name,date,artist,album,fav}

initPlayList(List<DataModel> songs, int i) async {
  await player.setAudioSource(
    ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: songs
            .map((e) => AudioSource.uri(Uri.file(e.path, windows: true),
                tag: AudioMetadata(
                  path: e.path,
                  title: e.title,
                  artist: e.artist,
                )))
            .toList()),
    initialIndex: i,
    initialPosition: Duration.zero,
  );
  await player.play();
}

initAudio() async {
  player = AudioPlayer();
  final session = await AudioSession.instance;
  await session.configure(AudioSessionConfiguration.speech());
}

disposeAudio() {
  player.stop();
  player.dispose();
}
