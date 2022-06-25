import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../adapter/songs_type_adapter.dart';
import '../services/hive_database/hive_database_impl.dart';
import '../services/hive_database/model/song.dart';
import '../utils/storge_utils.dart';
import 'di.config.dart';

final locator = GetIt.instance;

@injectableInit
Future<void> get configureDependencies async {
  await initHive;
  $initGetIt(locator);
  await locator.isReady<HiveDatabase>();
}

Future<void> get initHive async {
  Hive.init(await StorageUtils.getDocDir);
  Hive.registerAdapter<Song>(SongAdapter());
  locator.registerSingletonAsync<HiveDatabase>(
    () async {
      final hiveDatabase = HiveDatabase();
      await hiveDatabase.datasource.initDatabase;
      return hiveDatabase;
    },
  );
}
