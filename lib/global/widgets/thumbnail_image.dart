import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../core/di/di.dart';
import '../../core/services/hive_database/hive_database_impl.dart';

class ThumbnailImage extends StatefulWidget {
  final String path;
  final Duration? duration;
  final Uint8List? imageData;
  final int? hight;
  final int? width;
  final bool disableHeroAnimation;
  const ThumbnailImage(
      {required this.path,
      this.duration = const Duration(milliseconds: 500),
      this.imageData,
      this.hight,
      this.width,
      this.disableHeroAnimation = false,
      Key? key,})
      : super(key: key);

  @override
  State<ThumbnailImage> createState() => _ThumbnailImageState();
}

class _ThumbnailImageState extends State<ThumbnailImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: widget.duration);
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    super.initState();
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<Uint8List> getArt(String path) async =>
      locator<HiveDatabase>().getArt(path);

  @override
  Widget build(BuildContext context) => widget.disableHeroAnimation
      ? image()
      : Hero(tag: widget.path, child: image());

  Widget image() => widget.imageData != null
      ? Image(
          opacity: animation,
          fit: BoxFit.cover,
          image: ResizeImage.resizeIfNeeded(
            widget.hight,
            widget.width,
            MemoryImage(widget.imageData!),
          ),
          errorBuilder: (_, __, ___) =>
              Image.memory(locator<HiveDatabase>().datasource.imgThumbnail),
        )
      : FutureBuilder<Uint8List>(
          future: locator<HiveDatabase>().getArt(widget.path),
          builder: (context, snapshot) => snapshot.hasData
              ? Image(
                  opacity: animation,
                  fit: BoxFit.cover,
                  image: ResizeImage.resizeIfNeeded(
                    widget.hight,
                    widget.width,
                    MemoryImage(snapshot.data!),
                  ),
                  errorBuilder: (_, __, ___) => Image.memory(
                      locator<HiveDatabase>().datasource.imgThumbnail),
                )
              : const SizedBox(),
        );

  r() {}
}
