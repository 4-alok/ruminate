import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruminate/app/modules/home/controllers/home_controller.dart';
import 'package:ruminate/app/modules/home/controllers/tab_controller.dart';
import 'package:ruminate/app/modules/home/views/page/album_page.dart';
import 'package:ruminate/app/modules/home/views/page/artist_page.dart';
import 'package:ruminate/app/modules/home/views/page/folder_page.dart';
import 'package:ruminate/app/modules/home/views/page/home_page.dart';
import 'package:ruminate/app/modules/home/views/page/music_page.dart';
import 'package:ruminate/app/modules/home/views/page/test_page.dart';

class BodyWidget extends StatelessWidget {
  final HomeTabController tabController = Get.find<HomeTabController>();
  // final HomeController controller = Get.find<HomeController>();
          //   IconButton(
          //     onPressed: () => controller.clearDatabase(),
          //     icon: Icon(Icons.access_time),
          //   )
          // ],
          //   IconButton(
          //     onPressed: () => controller.clearDatabase(),
          //     icon: Icon(Icons.access_time),
          //   )
          // ],

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: tabController.tabList.length,
      child: Scaffold(
        appBar: AppBar(
          // actions: [
          //   IconButton(
          //     onPressed: () => controller.clearDatabase(),
          //     icon: Icon(Icons.access_time),
          //   )
          // ],
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
              children: [
                HomePage(tabController: tabController),
                MusicPage(),
                AlbumPage(tabController: tabController),
                ArtistPage(tabController: tabController),
                FolderPage(tabController: tabController),
                TestPage(),
              ],
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

