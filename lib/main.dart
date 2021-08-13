import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ruminate/app/utils/storage_utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/routes/app_pages.dart';
import 'app/services/database_service.dart';
import 'app/services/desktop_audio_services.dart';
import 'app/services/player_controller.dart';
import 'app/utils/database_model.dart';

void main() async {
  await init();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init(await StorageUtils.getDocDir());
  Hive.registerAdapter<Song>(SongAdapter());
  await Hive.openBox<Song>('songs_database');
  Get.lazyPut(() => SongDatabaseService());
  await SongDatabaseService().onInit();

  if (Platform.isLinux) {
    DartVLC.initialize();
    Get.lazyPut(() => DesktopAudioService());
  }

  Get.lazyPut(() => PlayerController());
}
