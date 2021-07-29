import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class StorageUtils {
  // Get the directory to store the music database or thumbnails,
  static Future<String> getDocDir() async {
    if (Platform.isAndroid) {
      WidgetsFlutterBinding.ensureInitialized();
      final String _dirPath =
          (await getExternalStorageDirectories())!.first.path;
      return _dirPath;
    } else if (Platform.isLinux) {
      final String _dirPath =
          (await getApplicationDocumentsDirectory()).path + "/.ruminate";
      final Directory _dir = new Directory(_dirPath);

      if (await _dir.exists()) {
        return _dirPath;
      } else {
        await _dir.create();
        return _dirPath;
      }
    }
    return "";
  }

  // Get the available directory to scan
  static Future<List<Directory>> getAvailableStorage() async {
    if (Platform.isLinux) {
      final Directory dir = await getApplicationDocumentsDirectory();
      return [dir.parent];
    } else if (Platform.isAndroid) {
      return await _getAndroidStorageList();
    } else
      return [];
  }

  static Future<List<Directory>> _getAndroidStorageList() async {
    List<Directory> storages = (await getExternalStorageDirectories())!;
    if (storages.length != 0)
      storages = storages.map((Directory e) {
        final List<String> splitedPath = e.path.split("/");
        return Directory(splitedPath
            .sublist(
                0, splitedPath.indexWhere((element) => element == "Android"))
            .join("/"));
      }).toList();
    else
      return [];
    return storages;
  }
}
