import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeTabController extends GetxController
    with SingleGetTickerProviderMixin {
  late final TabController tabController;

  final List<String> tabList = [
    'Home',
    'Music',
    'Album',
    'Artist',
    'Folder',
    'Test Page'
  ];
  late final List<Tab> tabs;

  @override
  void onInit() {
    tabs = tabList
        .map((e) => Tab(
                child: Text(
              e,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )))
        .toList();
    tabController = new TabController(
      length: tabList.length,
      vsync: this,
    );
    super.onInit();
  }
}
