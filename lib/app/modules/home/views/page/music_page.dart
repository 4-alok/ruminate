import 'package:flutter/material.dart';
import 'package:ruminate/app/modules/home/controllers/tab_controller.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final HomeTabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          tabController.tabList[1],
        ),
      ),
    );
  }
}
