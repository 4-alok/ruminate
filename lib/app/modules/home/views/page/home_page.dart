import 'package:flutter/material.dart';
import 'package:ruminate/app/modules/home/controllers/tab_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final HomeTabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          tabController.tabList[0],
        ),
      ),
    );
  }
}
