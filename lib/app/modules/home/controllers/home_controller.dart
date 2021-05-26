import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeController extends GetxController {
  late final PanelController panelController;

  RxBool panelHidden = false.obs;
  RxBool panelOpen = false.obs;
  RxDouble panel = 0.0.obs;

  @override
  void onInit() {
    panelController = new PanelController();
    super.onInit();
  }

  void panelOpenClose() {
    if (!panelOpen.value) {
      panelController.open();
      panelOpen.value = true;
    } else {
      panelController.close();
      panelOpen.value = false;
    }
  }
}
