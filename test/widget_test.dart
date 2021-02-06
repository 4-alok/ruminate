import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() async {
  for(Directory storagePath in (await getExternalStorageDirectories())){
    print(storagePath.path);
  }
}