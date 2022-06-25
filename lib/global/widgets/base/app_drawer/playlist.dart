import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawerPlaylist extends StatelessWidget {
  const AppDrawerPlaylist({Key? key}) : super(key: key);

  static Color iconColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? Colors.black54
          : Colors.white60;

  @override
  Widget build(BuildContext context) => Expanded(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) => PlaylistTile(
            leading: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.playlist_play_rounded,
                  size: 25,
                  color: iconColor(context),
                )),
            onTap: () {},
            title: 'Playlist $index',
            trailing: const TrailingIcons(),
          ),
        ),
      );
}

class PlaylistTile extends StatefulWidget {
  final String title;
  final Widget leading;
  final Widget trailing;
  final VoidCallback? onTap;
  const PlaylistTile(
      {required this.title,
      required this.leading,
      required this.trailing,
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  State<PlaylistTile> createState() => _PlaylistTileState();
}

class _PlaylistTileState extends State<PlaylistTile> {
  final visible = ValueNotifier<bool>(false);

  @override
  void dispose() {
    visible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: widget.onTap,
        onHover: (value) => visible.value = value,
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              const SizedBox(width: 5),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: widget.leading),
              Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const Spacer(),
              ValueListenableBuilder<bool>(
                valueListenable: visible,
                builder: (context, value, child) => AnimatedOpacity(
                  opacity: value ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: child,
                ),
                child: widget.trailing,
              ),
              const SizedBox(width: 25),
            ],
          ),
        ),
      );
}

class TrailingIcons extends StatelessWidget {
  const TrailingIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Wrap(children: [
        GestureDetector(
            onTap: () {},
            child: FaIcon(
              FontAwesomeIcons.play,
              size: 16,
              color: AppDrawerPlaylist.iconColor(context),
            )),
        const SizedBox(width: 16),
        GestureDetector(
            onTap: () {},
            child: FaIcon(
              FontAwesomeIcons.trash,
              size: 16,
              color: AppDrawerPlaylist.iconColor(context),
            )),
      ]);
}
