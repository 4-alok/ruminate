import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruminate/app/modules/home/controllers/animation_controller.dart';
import 'package:ruminate/app/modules/home/controllers/home_controller.dart';

class PanelWidget extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
  final HomeAnimationController animationController =
      Get.find<HomeAnimationController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amberAccent,
      child: Column(
        children: [
          toolBar(context),
          Container(),
        ],
      ),
    );
  }

  Widget toolBar(BuildContext context) {
    return Column(
      children: [
        Obx(() => Container(
              height: MediaQuery.of(context).padding.top *
                  homeController.panel.value,
              color: Colors.red,
            )),
        Container(
          color: Colors.blueAccent,
          padding: EdgeInsets.only(left: 10, right: 10),
          height: kToolbarHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              openCloseIcon(),
            ],
          ),
        ),
      ],
    );
  }

  Widget openCloseIcon() {
    return AnimatedBuilder(
      animation: animationController.rotateAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: animationController.rotateAnimation.value,
          child: child,
        );
      },
      child: IconButton(
        onPressed: () => homeController.panelOpenClose(),
        icon: Icon(Icons.keyboard_arrow_up_rounded),
      ),
    );
  }
}
