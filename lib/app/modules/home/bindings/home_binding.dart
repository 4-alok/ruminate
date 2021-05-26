import 'package:get/get.dart';
import 'package:ruminate/app/modules/home/controllers/animation_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<HomeAnimationController>(
      () => HomeAnimationController(),
    );
  }
}
