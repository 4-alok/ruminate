import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'home_controller.dart';

class HomeAnimationController extends GetxController
    with SingleGetTickerProviderMixin {
  late final AnimationController animationController;
  late final Animation<double> rotateAnimation;

  @override
  void onInit() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    super.onInit();

    Get.find<HomeController>().panel.listen((val) {
      if (val > 0.5) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });

    rotateAnimation =
        Tween<double>(begin: 0, end: math.pi).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
