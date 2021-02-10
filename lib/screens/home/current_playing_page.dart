import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ruminate/utils/audio_service.dart';
import 'package:ruminate/utils/thumbnail_widget.dart';

class CurrentPlayingPage extends StatefulWidget {
  CurrentPlayingPage({Key key}) : super(key: key);

  @override
  _CurrentPlayingPageState createState() => _CurrentPlayingPageState();
}

class _CurrentPlayingPageState extends State<CurrentPlayingPage>
    with SingleTickerProviderStateMixin {
  AnimationController playPauseController2;
  final currentPlayingPageController =
      PageController(initialPage: player.currentIndex);
  StreamSubscription<bool> isPlaying;
  StreamSubscription<int> _currentIndexStream;

  @override
  void initState() {
    super.initState();
    playPauseController2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );

    isPlaying = player.playingStream.listen((playing) {
      playing ? playPauseController2.forward() : playPauseController2.reverse();
    });

    _currentIndexStream = player.currentIndexStream.listen((event) {
      player.shuffleModeEnabled
          ? currentPlayingPageController.jumpToPage(event)
          : currentPlayingPageController.animateToPage(event,
              duration: Duration(milliseconds: 400), curve: Curves.decelerate);
    });
  }

  @override
  void dispose() {
    isPlaying.cancel();
    _currentIndexStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            child: PageView.builder(
              onPageChanged: (val) async {
                if (val == player.currentIndex + 1) {
                  await player.seekToNext();
                } else if (val == player.currentIndex - 1) {
                  await player.seekToPrevious();
                }
              },
              controller: currentPlayingPageController,
              itemCount: playlist.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: FutureBuilder(
                        future:
                            Thumbnail().getThumb(playlist[index].path.hashCode),
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
                            return Image.memory(
                              snapshot.data,
                              fit: BoxFit.cover,
                            );
                          }
                        },
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          color: Colors.transparent,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .760,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4)
                        ],
                        stops: [0.8, 1],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                    ),
                  ],
                );
              },
            ),
          ),
          mainPlayingPage(context)
        ],
      ),
    );
  }

  Container mainPlayingPage(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<int>(
              stream: player.currentIndexStream,
              builder: (context, snapshot) {
                return Container(
                    width: MediaQuery.of(context).size.height,
                    height: MediaQuery.of(context).size.height * .12,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          playlist[snapshot.data + 1].title == null
                              ? ""
                              : "• Next Song •",
                          style: TextStyle(color: Colors.white.withOpacity(.8)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          playlist[snapshot.data + 1].title == null
                              ? ""
                              : playlist[snapshot.data + 1].title,
                          style: Theme.of(context).textTheme.subtitle1,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ));
              }),
          Container(
            width: 0,
            height: MediaQuery.of(context).size.height * .640,
          ),
          Container(
            color: Colors.black.withOpacity(.4),
            // color: Colors.green,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .240,
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
                          icon: Icon(Icons.favorite_outline),
                          onPressed: () {},
                        ),
                        title: Text(
                          playlist[snapshot.data].title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          playlist[snapshot.data].artist == ""
                              ? "<Unknown Artist>"
                              : playlist[snapshot.data].artist,
                          style: Theme.of(context).textTheme.overline,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {},
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
                                  progress: playPauseController2,
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

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String min = twoDigits(duration.inMinutes.remainder(60));
    String sec = twoDigits(duration.inSeconds.remainder(60));
    return twoDigits(duration.inHours) == "00"
        ? "$min:$sec"
        : "${twoDigits(duration.inHours)}:$min:$sec";
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
          trackHeight: 1,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Slider(
          label: "hello",
          min: 0.0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
              widget.duration.inMilliseconds.toDouble()),
          onChanged: (value) {
            setState(() {
              _dragValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged(Duration(milliseconds: value.round()));
            }
          },
          onChangeEnd: (value) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd(Duration(milliseconds: value.round()));
            }
            _dragValue = null;
          },
        ),
      ),
    );
  }
}
