import 'package:get/get.dart';
import 'package:ruminate/app/utils/database_utils.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeController extends GetxController {
  late final PanelController panelController;

  RxBool panelHidden = false.obs;
  RxBool panelOpen = false.obs;
  RxDouble panel = 0.0.obs;

  @override
  void onInit() {
    SongDatabase().updateDatabase();
    panelController = new PanelController();
    super.onInit();
  }

  // void searchSong() async {
  //   // await SongDatabase().forceUpdateDatabase();
  //   SongDatabase().updateDatabase();
  // }

  void updateDatabase() async {
    await SongDatabase().forceUpdateDatabase();
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
