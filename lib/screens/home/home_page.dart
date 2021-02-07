import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ruminate/screens/home/folder_page.dart';
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
  final _panelController = PanelController();
  Box<DataModel> dataBox;
  final ValueNotifier<double> height = ValueNotifier<double>(0);

  StreamSubscription<int> _currentIndexStream;
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

    _currentIndexStream = player.currentIndexStream.listen((index) {
      if (index == null || index == -1) {
        height.value = 0;
      } else
        height.value = 55;
    });
  }

  @override
  void dispose() {
    super.dispose();
    dataBox.close();
    Hive.close();
    isPlaying.cancel();
    _currentIndexStream.cancel();
    disposeAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder<double>(
          valueListenable: height,
          builder: (context, snapshot, child) {
            return SlidingUpPanel(
                controller: _panelController,
                parallaxEnabled: true,
                minHeight: snapshot,
                maxHeight: MediaQuery.of(context).size.height,
                body: Scaffold(
                  appBar: AppBar(
                    title: Text('Music'),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => MusicDatabase().getAudio(),
                      ),
                      IconButton(
                        icon: Icon(Icons.functions),
                        onPressed: () {},
                      )
                    ],
                  ),
                  backgroundColor: Colors.black,
                  body: Stack(
                    children: [
                      AnimatedContainer(
                        padding: EdgeInsets.only(
                            bottom: snapshot +
                                //  MediaQuery.of(context).padding.top
                                MediaQuery.of(context).padding.bottom
                            // AppBar().preferredSize.height
                            ),
                        duration: Duration(microseconds: 400),
                        child: PageView.builder(
                          itemCount: 3,
                          itemBuilder: (context, i) {
                            switch (i) {
                              case 0:
                                return MusicListPage(dataBox: dataBox);
                              case 1:
                                return AlbumListPage(dataBox: dataBox);
                              case 2:
                                return FolderMusicPage(dataBox: dataBox);
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
                ),
                collapsed: Container(
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MiniSeekBar(),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RotatedBox(
                              quarterTurns: 3,
                              child: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  onPressed: () {
                                    _panelController.open();
                                  }),
                            ),
                            StreamBuilder<int>(
                              stream: player.currentIndexStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<int> snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data == -1) {
                                    return Text('');
                                  }
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * .7,
                                    child: Text(
                                      playlist[snapshot.data].title,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                panel: StreamBuilder<int>(
                    stream: player.currentIndexStream,
                    builder: (context, snapshot) {
                      if ((!snapshot.hasData) || (snapshot.data == -1)) {
                        // _panelController.hide();
                        return Container(
                          color: Colors.black,
                        );
                      } else {
                        // _panelController.show();
                        return CurrentPlayingPage();
                      }
                    }));
          }),
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
                return Container(
                  color: Colors.black,
                );
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
