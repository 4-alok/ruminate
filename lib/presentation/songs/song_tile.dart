// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../core/di/di.dart';
import '../../core/services/app_services/app_service.dart';
import '../../core/services/hive_database/model/song.dart';
import '../../global/widgets/thumbnail_image.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final int index;
  final VoidCallback onTap;
  const SongTile({
    Key? key,
    required this.song,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width -
        (locator<AppService>().isAppDrawerOpen ? 270 : 50);
    return Material(
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.grey[800],
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () => onTap(),
        child: SizedBox(
          height: 52,
          width: width,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  height: 42,
                  width: 42,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: ThumbnailImage(width: 42, path: song.path)),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: width * .26,
                child: Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                width: width * .21,
                child: Text(
                  song.album,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                width: width * .21,
                child: Text(
                  song.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                // width: width * .21,
                child: Text(
                  song.genre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SizedBox(
                  child: Text(
                    song.duration,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
