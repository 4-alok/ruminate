// import 'dart:async';

// import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';

// class AudioPlayerTask extends BackgroundAudioTask {
//   final _audioPlayer = AudioPlayer();
//   final _completer = Completer();

//   @override
//   Future<void> onStart(Map<String, dynamic> params) async {
//     // return super.onStart(params);
//     AudioServiceBackground.setState(
//         controls: [MediaControl.pause, MediaControl.stop],
//         playing: true,
//         processingState: AudioProcessingState.connecting);
//     await _audioPlayer.setFilePath(
//         '/storage/6148-100D/Music/Eng/Entertainer-Songspkhero.com.mp3');
//     _audioPlayer.play();
//     AudioServiceBackground.setState(
//         controls: [MediaControl.pause, MediaControl.stop],
//         playing: true,
//         processingState: AudioProcessingState.ready);
//   }

//   @override
//   Future<void> onPlay() {
//     AudioServiceBackground.setState(
//         controls: [MediaControl.pause, MediaControl.stop],
//         playing: true,
//         processingState: AudioProcessingState.ready);
//     _audioPlayer.play();
//   }

//   @override
//   Future<void> onPause() {
//     AudioServiceBackground.setState(
//         controls: [MediaControl.play, MediaControl.stop],
//         playing: false,
//         processingState: AudioProcessingState.ready);
//     _audioPlayer.pause();
//   }

//   @override
//   Future<void> onStop() async {
//     await _audioPlayer.stop();
//     await AudioServiceBackground.setState(
//       controls: [],
//       playing: false,
//       processingState: AudioProcessingState.stopped,
//     );
//     await super.onStop();
//   }

// }
