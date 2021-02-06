import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'albumPage.dart';
import '../../models/data_model.dart';
import '../../utils/database.dart';
import '../../utils/audio_service.dart';
import 'current_playing_page.dart';
import 'musicList.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController playPauseController;
  Box<DataModel> dataBox;
  double height = 55;

  StreamSubscription<bool> isPlaying;

  @override
  void initState() {
    super.initState();

    initAudio();
    dataBox = Hive.box<DataModel>('data');

    playPauseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );

    isPlaying = player.playingStream.listen((playing) {
      playing ? playPauseController.forward() : playPauseController.reverse();
    });
  }

  @override
  void dispose() {
    super.dispose();
    dataBox.close();
    Hive.close();
    isPlaying.cancel();
    disposeAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Music'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => MusicDatabase().getAudio(),
          ),
          IconButton(
            icon: Icon(Icons.functions),
            onPressed: () {
              print('--------------------> Here');
            },
          )
        ],
      ),
      body: SlidingUpPanel(
          parallaxEnabled: true,
          minHeight: height,
          maxHeight: MediaQuery.of(context).size.height,
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                    bottom: height +
                        MediaQuery.of(context).padding.top +
                        MediaQuery.of(context).padding.bottom +
                        AppBar().preferredSize.height),
                child: PageView.builder(
                  itemCount: 2,
                  itemBuilder: (context, i) {
                    switch (i) {
                      case 0:
                        return MusicListPage(dataBox: dataBox);
                      case 1:
                        return AlbumListPage(dataBox: dataBox);
                      default:
                        return Container(
                          color: Colors.amber,
                        );
                    }
                  },
                ),
              )
            ],
          ),
          collapsed: Container(
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MiniSeekBar(),
                Container(
                  height: 40,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text("data"),
                      StreamBuilder(
                        stream: player.currentIndexStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<int> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data == -1) {
                              return Text('');
                            }
                            return Container(
                              // color: Colors.green,
                              width: MediaQuery.of(context).size.width * .75,
                              child: Text(
                                playlist[snapshot.data].title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            return Text('');
                          }
                        },
                      ),
                      IconButton(
                          icon: AnimatedIcon(
                            icon: AnimatedIcons.play_pause,
                            progress: playPauseController,
                            size: 30,
                          ),
                          onPressed: () => floatingButton())
                    ],
                  ),
                ),
              ],
            ),
          ),
          panel: CurrentPlayingPage()),
    );
  }

  floatingButton() async {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }
}

class MiniSeekBar extends StatelessWidget {
  const MiniSeekBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: player.durationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final duration = snapshot.data ?? Duration.zero;
          return StreamBuilder<Duration>(
            stream: player.positionStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var position = snapshot.data ?? Duration.zero;
                if (position > duration) {
                  position = duration;
                }
                double pos;
                pos = position.inMilliseconds.toDouble() /
                    duration.inMilliseconds.toDouble();
                return Container(
                  height: 5,
                  color: Colors.blue,
                  constraints: BoxConstraints(
                      minWidth: 0, maxWidth: MediaQuery.of(context).size.width),
                  width: MediaQuery.of(context).size.width * pos,
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return Container(height: 5);
        }
      },
    );
  }
}
