import 'package:flutter/material.dart';

import '../presentation/albums/album_page.dart';
import '../presentation/albums/album_songs_page.dart/album_song_page.dart';
import '../presentation/artists/artist_page.dart';
import '../presentation/artists/artist_songs_page.dart';
import '../presentation/genres/genere_page.dart';
import '../presentation/genres/genere_songs_page.dart';
import '../presentation/songs/songs_page.dart';

part 'page_path.dart';

class AppRouter {
  static const initialRoute = Routes.SONGS;

  static Map<String, WidgetBuilder> appRouter(BuildContext context) => {
        Routes.SONGS: (_) => const SongsPage(),
        Routes.ALBUMS: (_) => const AlbumPage(),
        Routes.ARTISTS: (_) => const ArtistPage(),
        Routes.GENERES: (_) => const GenerePage(),
        Routes.ALBUM_SONGS: (_) => const AlbumSongsPage(),
        Routes.ARTIST_SONGS: (_) => const ArtistSongsPage(),
        Routes.GENERE_SONGS: (_) => const GenereSongsPage(),
      };
}
