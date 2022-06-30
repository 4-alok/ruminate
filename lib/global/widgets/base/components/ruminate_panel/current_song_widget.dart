// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

import 'package:ruminate/global/widgets/base/components/ruminate_panel/panel_utils.dart';

import '../../../marquee_text.dart';
import '../../../thumbnail_image.dart';

class CurrentSongWidget extends StatelessWidget with PanelUtils {
  final double? width;
  const CurrentSongWidget({this.width, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => appService.panelController.open(),
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
                      SizedBox(
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
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width:
                            (width ?? MediaQuery.of(context).size.width * 0.2) -
                                85,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                height: 25,
                                width: (width ??
                                        MediaQuery.of(context).size.width *
                                            0.2) -
                                    85,
                                child: MarqueeText(
                                  child: Text(
                                    song?.title ?? '',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            const SizedBox(height: 5),
                            Text(
                              song?.artist ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  );
                }),
          ),
        ),
      );
}
