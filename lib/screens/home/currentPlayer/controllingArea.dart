import 'dart:async';
import 'package:Ruminate/main.dart';
import 'package:Ruminate/models/data_model.dart';
import 'package:Ruminate/screens/widget/song_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Ruminate/screens/home/currentPlayer/seekBar.dart';
import 'package:Ruminate/utils/database.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import '../../../utils/audio_service.dart';
import 'package:flutter/material.dart';

class ControllingArea extends StatefulWidget {
  ControllingArea({
    Key key,
    @required this.dataBox,
  }) : super(key: key);
  Box<DataModel> dataBox;
  @override
  _ControllingAreaState createState() => _ControllingAreaState();
}

class _ControllingAreaState extends State<ControllingArea>
    with SingleTickerProviderStateMixin {
  AnimationController playPauseAController;
  StreamSubscription<bool> isPlaying;
  @override
  void initState() {
    playPauseAController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
    isPlaying = player.playingStream.listen((playing) {
      playing ? playPauseAController.forward() : playPauseAController.reverse();
    });
    super.initState();
  }

  @override
  void dispose() {
    playPauseAController.dispose();
    isPlaying.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<int>(
              stream: player.currentIndexStream,
              builder: (context, snapshot) {
                if (!player.hasNext) {
                  return Container();
                }
                return Container(
                    width: MediaQuery.of(context).size.height,
                    margin: EdgeInsets.only(
                        right: 25,
                        left: 25,
                        top: MediaQuery.of(context).padding.top + 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          // playlist[snapshot.data + 1].title == null
                          player.sequence[snapshot.data + 1].tag.title == null
                              ? ""
                              : "• Next Song •",
                          style: TextStyle(color: Colors.white.withOpacity(.8)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          player.sequence[snapshot.data + 1].tag.title == null
                              ? ""
                              : player.sequence[snapshot.data + 1].tag.title,
                          style: Theme.of(context).textTheme.subtitle1,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ));
              }),
          Container(
            // color: Colors.black.withOpacity(.4),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<int>(
                    stream: player.currentIndexStream,
                    builder: (context, snapshot) {
                      return ListTile(
                        leading: IconButton(
                            onPressed: () => fav(),
                            icon: ValueListenableBuilder<Box<dynamic>>(
                                valueListenable: favList.listenable(),
                                builder: (context, snapshot, child) {
                                  var l = snapshot.values.toList();
                                  return Icon(l.contains(player
                                          .sequence[player.currentIndex]
                                          .tag
                                          .path)
                                      ? Icons.favorite
                                      : Icons.favorite_outline);
                                })),
                        title: Text(
                          player.sequence[snapshot.data].tag.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          player.sequence[snapshot.data].tag.artist == ""
                              ? "<Unknown Artist>"
                              : player.sequence[snapshot.data].tag.artist,
                          style: Theme.of(context).textTheme.overline,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () => showDiaglog(
                              context, player.sequence[snapshot.data].tag.path),
                        ),
                      );
                    }),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      StreamBuilder<Duration>(
                        stream: player.positionStream,
                        builder: (context, snapshot) {
                          return !snapshot.hasData
                              ? Container()
                              : Text(
                                  _printDuration(snapshot.data),
                                  style: Theme.of(context).textTheme.overline,
                                );
                        },
                      ),
                      StreamBuilder<Duration>(
                        stream: player.durationStream,
                        builder: (context, snapshot) {
                          return !snapshot.hasData
                              ? Container()
                              : Text(
                                  _printDuration(snapshot.data),
                                  style: Theme.of(context).textTheme.overline,
                                );
                        },
                      ),
                    ],
                  ),
                ),
                StreamBuilder<Duration>(
                  stream: player.durationStream,
                  builder: (context, snapshot) {
                    final duration = snapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration>(
                      stream: player.positionStream,
                      builder: (context, snapshot) {
                        var position = snapshot.data ?? Duration.zero;
                        if (position > duration) {
                          position = duration;
                        }
                        return SeekBar(
                          duration: duration,
                          position: position,
                          onChangeEnd: (newPosition) {
                            player.seek(newPosition);
                          },
                        );
                      },
                    );
                  },
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: StreamBuilder<LoopMode>(
                              stream: player.loopModeStream,
                              builder: (context, snapshot) {
                                if (snapshot.data == LoopMode.off) {
                                  return Icon(
                                    Icons.loop,
                                    color: Colors.grey,
                                  );
                                } else if (snapshot.data == LoopMode.all) {
                                  return Icon(
                                    Icons.loop,
                                    color: Colors.white,
                                  );
                                }
                                return Icon(Icons.repeat_one);
                              }),
                          onPressed: () {
                            if (player.loopMode == LoopMode.off) {
                              player.setLoopMode(LoopMode.all);
                            } else if (player.loopMode == LoopMode.all) {
                              player.setLoopMode(LoopMode.one);
                            } else {
                              player.setLoopMode(LoopMode.off);
                            }
                          }),
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () async {
                            await player.seekToPrevious();
                          }),
                      SizedBox.fromSize(
                        size: Size(56, 56), // button width and height
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // button color
                            child: InkWell(
                              onTap: () {
                                if (player.playing) {
                                  player.pause();
                                } else {
                                  player.play();
                                }
                              }, // button pressed
                              child: Center(
                                child: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  progress: playPauseAController,
                                  // size: 30,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () async {
                            return player.seekToNext();
                          }),
                      IconButton(
                          icon: StreamBuilder<bool>(
                              stream: player.shuffleModeEnabledStream,
                              builder: (context, snapshot) {
                                return Icon(
                                  Icons.shuffle,
                                  color: snapshot.data
                                      ? Colors.white
                                      : Colors.grey,
                                );
                              }),
                          onPressed: () {
                            !player.shuffleModeEnabled
                                ? player.setShuffleModeEnabled(true)
                                : player.setShuffleModeEnabled(false);
                          })
                    ])
              ],
            ),
          )
        ],
      ),
    );
  }

  void fav() async {
    await MusicDatabase().fav();
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String min = twoDigits(duration.inMinutes.remainder(60));
    String sec = twoDigits(duration.inSeconds.remainder(60));
    return twoDigits(duration.inHours) == "00"
        ? "$min:$sec"
        : "${twoDigits(duration.inHours)}:$min:$sec";
  }
}
