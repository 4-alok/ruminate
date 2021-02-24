import 'package:Ruminate/models/data_model.dart';
import 'package:Ruminate/models/model.dart';
import 'package:just_audio/just_audio.dart';

AudioPlayer player;

enum Sorting { name, date, fav }

List<AudioSource> playlist = [];

void setPlayList(List<DataModel> songs) {
  playlist = songs
      .map((e) => AudioSource.uri(Uri.file(e.path, windows: true),
          tag: AudioMetadata(
            path: e.path,
            title: e.title,
            artist: e.artist,
          )))
      .toList();
}

void playAudio(int i) async {
  try {
    await player.setAudioSource(
      ConcatenatingAudioSource(useLazyPreparation: true, children: playlist),
      initialIndex: i,
      initialPosition: Duration.zero,
    );
  } on PlayerException catch (e) {
    print("Error message: ${e.message}");
  } on PlayerInterruptedException catch (e) {
    print("Connection aborted: ${e.message}");
  } catch (e) {
    print(e);
  }
  await player.play();
}

initAudio() async {
  player = AudioPlayer();
  // final session = await AudioSession.instance;
  // await session.configure(AudioSessionConfiguration.speech());
}

disposeAudio() {
  player.stop();
  player.dispose();
}
