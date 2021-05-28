import 'dart:isolate';

import 'package:get/get.dart';

class FindSong {
  Isolate? isolate;
  RxBool running = false.obs;
  ReceivePort? receivePort;

  void findSong() async {
    running.value = true;
    receivePort = ReceivePort();
    isolate = await Isolate.spawn(checkTimer, receivePort!.sendPort);
    receivePort!.listen((data) {}, onDone: () {
      print("done!");
    });
  }

  static void checkTimer(SendPort sendPort) async {
    
    sendPort.send('msg');
  }

  void stop() {
    if (isolate != null) {
      receivePort!.close();
      isolate!.kill(priority: Isolate.immediate);
      isolate = null;
    }
  }
}
