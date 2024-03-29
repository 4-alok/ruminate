import 'package:flutter/material.dart';
import 'package:ruminate/core/services/app_services/app_service.dart';
import 'package:ruminate/core/services/music_player_service/music_player_service.dart';

import '../../../core/di/di.dart';
import 'app_drawer/app_drawer.dart';
import 'components/ruminate_panel/ruminate_panel.dart';
import 'components/sliding_up_panel.dart';
import 'components/windows_titlebar_box.dart';

class LargeScreenBase extends StatefulWidget {
  final String? title;
  final Widget body;
  final Widget? secondaryToolbar;
  final List<Widget> actions;
  const LargeScreenBase(
      {this.title,
      this.secondaryToolbar,
      required this.body,
      this.actions = const [],
      Key? key})
      : super(key: key);

  @override
  State<LargeScreenBase> createState() => _LargeScreenBaseState();
}

class _LargeScreenBaseState extends State<LargeScreenBase>
    with SingleTickerProviderStateMixin {
  late final AnimationController drawerSize;

  AppService get appService => locator<AppService>();

  @override
  void initState() {
    drawerSize = AnimationController(
        upperBound: 270,
        lowerBound: 50,
        vsync: this,
        duration: const Duration(milliseconds: 150));
    drawerSize.value =
        appService.appDrawerState.value == AppDrawerState.open ? 270 : 50;
    appService.appDrawerState.addListener(() {
      appService.appDrawerState.value == AppDrawerState.open
          ? drawerSize.forward()
          : drawerSize.reverse();
    });
    super.initState();
  }

  @override
  void dispose() {
    drawerSize.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Material(
        child: SlidingUpPanel(
          color: Theme.of(context).scaffoldBackgroundColor,
          maxHeight: MediaQuery.of(context).size.height - 40,
          minHeight: 70,
          controller: appService.panelController,
          collapsed: const RuminatePanel(),
          slidePosition: (value) => (value >= 0.0 && value <= 1.0)
              ? appService.slidingPosition.value = value
              : null,
          panel: const Hero(
              tag: 'panel',
              child: Center(
                child: Text("Panel"),
              )),
          body: LayoutBuilder(
            builder: (context, boxConstraints) {
              if (!locator<MusicPlayerService>()
                  .audioService
                  .getPlayer
                  .playback
                  .isPlaying) {
                appService.panelController.hide();
              }
              appService.appDrawerState.value = (boxConstraints.maxWidth > 1200)
                  ? AppDrawerState.open
                  : AppDrawerState.close;
              return Row(
                children: [drawer(boxConstraints), body],
              );
            },
          ),
        ),
      );

  Widget get body => AnimatedBuilder(
        animation: drawerSize,
        builder: (context, child) => Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width - drawerSize.value,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: child!,
        ),
        child: Stack(
          children: [
            NotificationListener(
              onNotification: (_) => true,
              child: widget.body,
            ),
            WindowsTitlebarBox(
              title: widget.title,
              actions: widget.actions,
              secondaryToolbarWidget: widget.secondaryToolbar,
            ),
          ],
        ),
      );

  Widget drawer(BoxConstraints boxConstraints) => Hero(
        tag: "drawer",
        child: AnimatedBuilder(
          animation: drawerSize,
          builder: (context, child) => Container(
            width: drawerSize.value,
            height: double.maxFinite,
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.95),
            child: const AppDrawer(),
          ),
        ),
      );
}
