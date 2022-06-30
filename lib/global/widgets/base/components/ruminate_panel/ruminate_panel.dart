import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ruminate/global/widgets/base/components/ruminate_panel/panel_utils.dart';

import 'controller_widget.dart';
import 'current_song_widget.dart';

class RuminatePanel extends StatelessWidget with PanelUtils {
  const RuminatePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Hero(
        tag: 'collapsed',
        child: Material(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: LayoutBuilder(
              builder: (context, boxConstraints) =>
                  (boxConstraints.maxWidth < 600)
                      ? shortPanel(context)
                      : widePanel(context, boxConstraints),
            ),
          ),
        ),
      );

  Widget shortPanel(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              color: Colors.green,
              child: Container(
                  color: Colors.red,
                  child: CurrentSongWidget(
                    width: MediaQuery.of(context).size.width * .6,
                  ))),
          // MusicControllerWidget(),
        ],
      );

  Widget widePanel(BuildContext context, BoxConstraints boxConstraints) => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: const CurrentSongWidget(),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width *
                ((boxConstraints.maxWidth < 600) ? 0.8 : 0.6),
            child: const MusicControllerWidget(),
          ),
          (boxConstraints.maxWidth < 1200)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: const Align(
                      alignment: Alignment.center,
                      child: FaIcon(FontAwesomeIcons.volumeHigh)))
              : SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: volumeWidget,
                ),
        ],
      );

  Widget get volumeWidget => Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(FontAwesomeIcons.volumeHigh),
            const SizedBox(width: 10),
            Container(
              height: 3,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.5),
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
}
