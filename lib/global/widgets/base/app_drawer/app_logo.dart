import 'package:flutter/material.dart';
import 'package:ruminate/global/widgets/base/app_drawer/playlist.dart';

import '../../../../core/di/di.dart';
import '../../../../core/services/app_services/app_service.dart';

class AppLogo extends StatefulWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> {
  AppService get appService => locator<AppService>();

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: appService.appDrawerState,
        builder: (context, value, child) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          child: appService.isAppDrawerOpen
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AnimatedBuilder(
                    animation: appService.slidingPosition,
                    builder: (context, child) => Text(
                      'Ruminate',
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontSize: 35 -
                                locator<AppService>().slidingPosition.value *
                                    15,
                          ),
                    ),
                  ))
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: AnimatedBuilder(
                    animation: appService.slidingPosition,
                    builder: (context, child) => Icon(
                      Icons.music_note,
                      size: 39.0 - (appService.slidingPosition.value * 15),
                      color: AppDrawerPlaylist.iconColor(context),
                    ),
                  )),
        ),
      );
}
