import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruminate/app/global/widgets/global_widget.dart';
import 'package:ruminate/app/services/database_service.dart';

class AlbumPage extends StatelessWidget {
  final SongDatabaseService songDatabase = Get.find<SongDatabaseService>();

  Widget layoutBuilder(BuildContext context) {
    return LayoutBuilder(builder: (context, constaints) {
      final crossAxisCount = constaints.maxWidth ~/ 250;
      return GridView.builder(
        addAutomaticKeepAlives: true,
        itemCount: songDatabase.albums.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return MaterialButton(
            onPressed: () {},
            child: Container(
                child: Stack(
              children: [
                GlobalWidget.image(songDatabase.albums[index].artPath),
              ],
            )),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() {
        return (songDatabase.albums.length == 0)
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : layoutBuilder(context);
      }),
    );
  }
}
