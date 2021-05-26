import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruminate/app/modules/home/controllers/tab_controller.dart';

class BodyWidget extends StatelessWidget {
  final HomeTabController tabController = Get.find<HomeTabController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabController.tabList.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            alignment: Alignment.bottomLeft,
            child: TabBar(
              indicatorColor: Colors.transparent,
              controller: tabController.tabController,
              isScrollable: true,
              tabs: tabController.tabs,
            ),
          ),
        ),
        body: Container(
            margin: EdgeInsets.only(bottom: kToolbarHeight),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              controller: tabController.tabController,
              children: tabController.tabList
                  .map((e) => Container(
                        child: Center(
                            child: Text(
                          e,
                          style: Theme.of(context).textTheme.headline2,
                        )),
                      ))
                  .toList(),
            )),
      ),
    );
  }

  ListView testListView() {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          onTap: () {},
          leading: CircleAvatar(
            child: Text("$index"),
          ),
          title: Text("Title"),
          subtitle: Text("Subtitle"),
        ),
      ),
    );
  }
}
