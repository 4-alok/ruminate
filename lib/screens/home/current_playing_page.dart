import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
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

  StreamSubscription<bool> isPlaying;

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
  }

  @override
  void dispose() {
    isPlaying.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          StreamBuilder(
            stream: player.currentIndexStream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Thumbnail().imageThumbnail(
                    playlist[snapshot.data].path.hashCode, BoxFit.cover),
              );
            },
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
            height: MediaQuery.of(context).size.height * .7,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
              stops: [0.8, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
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
          Container(
            width: 0,
            height: MediaQuery.of(context).size.height * .70,
          ),
          Container(
            color: Colors.black.withOpacity(.4),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      StreamBuilder(
                        stream: player.positionStream,
                        builder: (context, snapshot) {
                          return !snapshot.hasData
                              ? Container()
                              : Text(
                                  _printDuration(snapshot.data),
                                  // style: Theme.of(context).textTheme.headline6,
                                );
                        },
                      ),
                      StreamBuilder(
                        stream: player.durationStream,
                        builder: (context, snapshot) {
                          return !snapshot.hasData
                              ? Container()
                              : Text(
                                  _printDuration(snapshot.data),
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
                      IconButton(icon: Icon(Icons.loop), onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () => player.seekToPrevious()),
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
                          onPressed: () => player.seekToNext()),
                      IconButton(icon: Icon(Icons.shuffle), onPressed: () {}),
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
        // color: Colors.green,
        width: MediaQuery.of(context).size.width,
        child: Slider(
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
