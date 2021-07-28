import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class StorageUtils {
  static Future<String> getDocDir() async {
    if (Platform.isAndroid) {
      WidgetsFlutterBinding.ensureInitialized();
      final _dirPath =
          ((await getExternalStorageDirectories()) ?? [Directory("")]).first.path;
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
}
