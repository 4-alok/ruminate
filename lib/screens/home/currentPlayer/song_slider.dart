import 'dart:async';
import 'dart:typed_data';

import 'package:Ruminate/utils/audio_service.dart';
import 'package:Ruminate/utils/thumbnail_manager.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SongSlider extends StatefulWidget {
  const SongSlider({
    Key key,
  }) : super(key: key);

  @override
  _SongSliderState createState() => _SongSliderState();
}

class _SongSliderState extends State<SongSlider> {
  final currentPlayingPageController =
      PageController(initialPage: player.currentIndex);
  final tagger = new Audiotagger();
  StreamSubscription<int> _currentIndexStream;

  @override
  void initState() {
    _currentIndexStream = player.currentIndexStream.listen((event) {
      player.shuffleModeEnabled
          ? currentPlayingPageController.jumpToPage(event)
          : currentPlayingPageController.animateToPage(event,
              duration: Duration(milliseconds: 400), curve: Curves.decelerate);
    });
    super.initState();
  }

  @override
  void dispose() {
    currentPlayingPageController.dispose();
    _currentIndexStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * .6,
          // width: 100,
          // color: Colors.green,
          child: GestureDetector(
            onTap: () async {
              player.playing ? player.pause() : await player.play();
            },
            child: StreamBuilder<List<IndexedAudioSource>>(
                stream: player.sequenceStream,
                builder: (context, snapshot) {
                  return PageView.builder(
                    onPageChanged: (val) async {
                      if (val == player.currentIndex + 1) {
                        await player.seekToNext();
                      } else if (val == player.currentIndex - 1) {
                        await player.seekToPrevious();
                      }
                    },
                    controller: currentPlayingPageController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Center(
                            child: FutureBuilder(
                              future: getImage(snapshot.data[index].tag.path),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container(
                                    color: Colors.black,
                                    child: Center(
                                      child: Icon(
                                        Icons.music_note,
                                        size: 500,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Card(
                                    elevation: 10,
                                    child: Image.memory(
                                      snapshot.data,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> getImage(String path) async {
    return await tagger.readArtwork(path: path);
  }
}
