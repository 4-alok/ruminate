import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_size/window_size.dart';

import 'core/di/di.dart';
import 'global/transition/shared_axix_transition.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    doWhenWindowReady(() {
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
    setWindowTitle('Ruminate');
    setWindowMaxSize(Size.infinite);
    setWindowMinSize(const Size(512, 800));
  }
  await Window.initialize();
  await DartVLC.initialize();
  await configureDependencies.then(
    (value) => runApp(const Ruminate()),
  );
}

class Ruminate extends StatelessWidget {
  const Ruminate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ClipRRect(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ruminate',
          theme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.linux: SharedAxisTransitionBuilder()
              })),
          initialRoute: AppRouter.initialRoute,
          routes: AppRouter.appRouter(context),
        ),
      );
}
