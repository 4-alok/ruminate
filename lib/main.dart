import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/routes/app_pages.dart';
import 'app/services/database_service.dart';
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
  Get.lazyPut(() => SongDatabase());
  await Hive.initFlutter();
  Hive.registerAdapter<Song>(SongAdapter());
  await Hive.openBox<Song>('songs_database');
}
