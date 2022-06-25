import 'package:flutter/material.dart';
import 'package:ruminate/global/widgets/base/large_screen_base.dart';

import '../../../core/services/hive_database/model/artist.dart';

class ArtistSongsPage extends StatelessWidget {
  const ArtistSongsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final artist = ModalRoute.of(context)!.settings.arguments as Artist;
    return LargeScreenBase(
      title: artist.artistName,
      secondaryToolbar: secondaryToolBar(context),
      body: const Text("Artist Songs Page"),
    );
  }

  Widget secondaryToolBar(BuildContext context) => Row(
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              size: 35,
            ),
          ),
        ],
      );
}
