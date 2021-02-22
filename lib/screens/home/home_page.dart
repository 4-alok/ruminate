import 'dart:async';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:Ruminate/screens/widget/appBar.dart';
import 'package:Ruminate/utils/database.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../main.dart';
import '../../models/data_model.dart';
import '../../utils/audio_service.dart';
import '../../utils/notification_service.dart';
import 'albumPage.dart';
import 'musicList.dart';
import 'folder_page.dart';
import 'artist_page.dart';
import 'currentPlayer/current_playing_page.dart';

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
  final ValueNotifier<int> currentPage = ValueNotifier<int>(0);
  StreamSubscription<int> _currentIndexStream;
  StreamSubscription<bool> isPlaying;

  @override
  void initState() {
    super.initState();
    MusicDatabase().getAudio();
    initAudio();
    dataBox = Hive.box<DataModel>('data');
    playPauseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );

    isPlaying = player.playingStream.listen((playing) {
      playing ? playPauseController.forward() : playPauseController.reverse();
      if ((player.currentIndex != null) || (player.currentIndex != -1)) {
        NotificationServices().isPlaying(playing);
      }
    });

    _currentIndexStream = player.currentIndexStream.listen((index) {
      (index == null || index == -1) ? height.value = 0 : hasIndex(index);
    });
  }

  void hasIndex(int index) {
    height.value = 55;
    NotificationServices().updateNotificationContent(index);
  }

  @override
  void dispose() {
    super.dispose();
    dataBox.close();
    thumb.close();
    Hive.close();
    isPlaying.cancel();
    _currentIndexStream.cancel();
    NotificationServices().disposeNotification();
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
                  appBar: PreferredSize(
                    preferredSize: Size(MediaQuery.of(context).size.width,
                        AppBar().preferredSize.height),
                    child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        // alignment: Alignment.bottomLeft,
                        child: ValueListenableBuilder<int>(
                          valueListenable: currentPage,
                          builder: (context, snapshot, child) {
                            return CustumAppBar(
                                appbar: appbar(context), i: snapshot);
                          },
                        )),
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
                          itemCount: 4,
                          itemBuilder: (context, i) {
                            switch (i) {
                              case 0:
                                return MusicListPage(dataBox: dataBox);
                              case 1:
                                return AlbumListPage(dataBox: dataBox);
                              case 2:
                                return ArtistPage(dataBox: dataBox);
                              case 3:
                                return FolderMusicPage(dataBox: dataBox);
                              default:
                                return Container(
                                  color: Colors.amber,
                                );
                            }
                          },
                          onPageChanged: (val) {
                            currentPage.value = val;
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
                                      player.sequence[snapshot.data].tag.title,
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

class CustumAppBar extends StatefulWidget {
  const CustumAppBar({
    Key key,
    @required this.appbar,
    @required this.i,
  }) : super(key: key);

  final List<Widget> appbar;
  final int i;

  @override
  _CustumAppBarState createState() => _CustumAppBarState();
}

class _CustumAppBarState extends State<CustumAppBar> {
  double o = 0;
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(microseconds: 1), () {
      setState(() {
        o = 1;
      });
    });
    return AnimatedOpacity(
      opacity: o,
      duration: Duration(seconds: 1),
      child: widget.appbar[widget.i],
    );
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
