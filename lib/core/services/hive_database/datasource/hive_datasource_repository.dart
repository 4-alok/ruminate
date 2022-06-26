import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../../../../global/widgets/refresh_widget.dart';
import '../model/song.dart';

abstract class HiveDatasourceRepository {
  Future<void> get initDatabase;
  Future<void> updateDatabase(ValueNotifier<RefreshState> refreshState);
  Future<void> get clearDatabase;
  Future<void> get closeDatabase;
  List<Song> get getSongsList;
  Future<Uint8List> getArt(String path);
}
