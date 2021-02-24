import 'dart:ui';
import 'dart:async';
import 'package:Ruminate/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:Ruminate/utils/audio_service.dart';
import 'package:Ruminate/utils/thumbnail_manager.dart';

import 'controllingArea.dart';
import 'song_slider.dart';

class CurrentPlayingPage extends StatefulWidget {
  CurrentPlayingPage({Key key, @required this.dataBox}) : super(key: key);

  Box<DataModel> dataBox;

  @override
  _CurrentPlayingPageState createState() => _CurrentPlayingPageState();
}

class _CurrentPlayingPageState extends State<CurrentPlayingPage> {
  final currentPlayingPageController =
      PageController(initialPage: player.currentIndex);
  StreamSubscription<int> _currentIndexStream;

  @override
  void initState() {
    super.initState();

    _currentIndexStream = player.currentIndexStream.listen((event) {
      player.shuffleModeEnabled
          ? currentPlayingPageController.jumpToPage(event)
          : currentPlayingPageController.animateToPage(event,
              duration: Duration(milliseconds: 400), curve: Curves.decelerate);
    });
  }

  @override
  void dispose() {
    _currentIndexStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          blurBackground(),
          ControllingArea(dataBox: widget.dataBox,),
          SongSlider(),
        ],
      ),
    );
  }

  Stack blurBackground() {
    return Stack(
      children: [
        StreamBuilder<int>(
            stream: player.currentIndexStream,
            builder: (context, snapshot) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                  future: Thumbnail().getThumb(
                      player.sequence[snapshot.data].tag.path.hashCode),
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
              );
            }),
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
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.5),
              Colors.transparent,
              Colors.transparent,
              Colors.black.withOpacity(0.4)
            ],
            stops: [0.1, .2, .65, .85],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
        ),
      ],
    );
  }
}
