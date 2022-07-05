import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ruminate/core/extension/duration_to_string.dart';
import 'package:ruminate/global/widgets/base/components/ruminate_panel/panel_utils.dart';

import '../../../progress_bar.dart';

class MusicControllerWidget extends StatelessWidget with PanelUtils {
  final double? width;
  const MusicControllerWidget({this.width, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, boxConstraints) => Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: -5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder<PositionState>(
                  stream: audioService.audioService.getPlayer.positionStream,
                  builder: (context, snapshot) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text((snapshot.data?.position ?? Duration.zero)
                          .formatToString),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: width ??
                            MediaQuery.of(context).size.width * 0.6 - 180,
                        child: MusicProgressBar(
                          position: snapshot.data?.position ?? Duration.zero,
                          duration: snapshot.data?.duration ?? Duration.zero,
                          seekTo: (duration) =>
                              audioService.audioService.seek(duration),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text((snapshot.data?.duration ?? Duration.zero)
                          .formatToString)
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 5,
              left: 0,
              right: 0,
              child: Center(
                child: MiniController(),
              ),
            ),
          ],
        ),
      );
}

class MiniController extends StatelessWidget with PanelUtils {
  const MiniController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () => audioService.audioService.previous(),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: FaIcon(
                FontAwesomeIcons.backwardStep,
                size: 25,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () => audioService.audioService.getPlayer.playback.isPlaying
                ? audioService.audioService.pause()
                : audioService.audioService.play(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: StreamBuilder<PlaybackState>(
                  stream: audioService.audioService.getPlayer.playbackStream,
                  builder: (context, snapshot) {
                    if (snapshot.data?.isPlaying ?? true) {
                      return const FaIcon(
                        FontAwesomeIcons.pause,
                        size: 30,
                      );
                    } else {
                      return const FaIcon(
                        FontAwesomeIcons.play,
                        size: 30,
                      );
                    }
                  }),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () => audioService.audioService.next(),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: FaIcon(
                FontAwesomeIcons.forwardStep,
                size: 25,
              ),
            ),
          ),
        ],
      );
}
