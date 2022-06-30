import 'package:ruminate/core/services/hive_database/model/artist.dart';

import '../../hive_database/model/album.dart';
import '../../hive_database/model/genere.dart';
import '../../hive_database/model/song.dart';

abstract class MusicPlayerRepository {
  void playSongs(List<Song> songs ,[int index = 0]);
  void playAlbums(List<Album> albums);
  void playAlbum(Album album,[int index = 0]);
  void playArtists(List<Artist> songs);
  void playArtist(Artist artist,[int index = 0]);
  void playGenres(List<Genere> songs);
  void playGenre(Genere genre,[int index = 0]);
}