import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:ruminate/models/data_model.dart';
import 'package:ruminate/models/model.dart';

AudioPlayer player;

List<DataModel> playlist;

initPlayList(List<DataModel> songs, int i) async {
  playlist = [];
  playlist = songs;
  await player.setAudioSource(
    ConcatenatingAudioSource(
        useLazyPreparation: true,
        // shuffleOrder: DefaultShuffleOrder(),
        children: playlist
            .map((e) => AudioSource.uri(Uri.file(e.path, windows: true),tag: AudioMetadata(
              path: e.path
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

playAudio(String path) async {
  await player.setFilePath(path);
  player.play();
}
