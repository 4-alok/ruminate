// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

import 'package:ruminate/core/services/hive_database/model/song.dart';
import 'package:ruminate/global/widgets/base/components/ruminate_panel/panel_utils.dart';

import '../../../marquee_text.dart';
import '../../../thumbnail_image.dart';

class CurrentSongWidget extends StatefulWidget {
  final double? width;
  const CurrentSongWidget({this.width, Key? key}) : super(key: key);

  @override
  State<CurrentSongWidget> createState() => _CurrentSongWidgetState();
}

class _CurrentSongWidgetState extends State<CurrentSongWidget> with PanelUtils {
  final hover = ValueNotifier<bool>(false);

  @override
  void dispose() {
    hover.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => appService.panelController.open(),
          onHover: (hover) => this.hover.value = hover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: StreamBuilder<CurrentState>(
                stream: audioService.audioService.getPlayer.currentStream,
                builder: (context, snapshot) {
                  final song = getCurrentSong(
                      audioService.audioService.getPlayer.current);
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      songArt(song),
                      const SizedBox(width: 5),
                      songDetails(context, song),
                      const SizedBox(width: 5),
                    ],
                  );
                }),
          ),
        ),
      );

  SizedBox songDetails(BuildContext context, Song? song) => SizedBox(
        width: (widget.width ?? MediaQuery.of(context).size.width * 0.2) - 85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: 25,
                width:
                    (widget.width ?? MediaQuery.of(context).size.width * 0.2) -
                        85,
                child: MarqueeText(
                  hover: hover,
                  text: song?.title ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(height: 5),
            MarqueeText(
              hover: hover,
              text: song?.artist ?? '',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      );

  SizedBox songArt(Song? song) => SizedBox(
        height: 60,
        width: 60,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ThumbnailImage(
                  disableHeroAnimation: true,
                  hight: 60,
                  width: 60,
                  path: song?.path ?? ''),
            )),
      );
}
