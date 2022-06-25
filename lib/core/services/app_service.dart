import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:ruminate/core/services/hive_database/hive_database_impl.dart';

import '../di/di.dart';

enum CurrentPageState { songs, albums, artists, genres }

enum AppDrawerState { open, close }

@singleton
class AppService {
  final currentPageState =
      ValueNotifier<CurrentPageState>(CurrentPageState.songs);
  final databaseUpadting = ValueNotifier<bool>(false);
  final appDrawerState = ValueNotifier<AppDrawerState>(AppDrawerState.close);

  bool get isAppDrawerOpen => appDrawerState.value == AppDrawerState.open;

  @disposeMethod
  void close() async {
    appDrawerState.dispose();
    databaseUpadting.dispose();
    currentPageState.dispose();
    await locator<HiveDatabase>().datasource.closeDatabase;
  }
}
