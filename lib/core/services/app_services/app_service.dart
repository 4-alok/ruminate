import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:ruminate/core/services/hive_database/hive_database_impl.dart';

import '../../../global/widgets/base/components/sliding_up_panel.dart';
import '../../di/di.dart';

enum CurrentPageState { songs, albums, artists, genres }

enum AppDrawerState { open, close }

@singleton
class AppService {
  final currentPageState =
      ValueNotifier<CurrentPageState>(CurrentPageState.songs);
  final databaseUpadting = ValueNotifier<bool>(false);
  final appDrawerState = ValueNotifier<AppDrawerState>(AppDrawerState.close);
  final panelController = PanelController();
  final slidingPosition = ValueNotifier<double>(0.0);
  bool get isAppDrawerOpen => appDrawerState.value == AppDrawerState.open;

  @disposeMethod
  Future<void> close() async {
    appDrawerState.dispose();
    databaseUpadting.dispose();
    currentPageState.dispose();
    slidingPosition.dispose();
    await locator<HiveDatabase>().datasource.closeDatabase;
  }
}
