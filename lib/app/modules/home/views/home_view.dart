import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'components/body_widget.dart';
import 'components/panel_widget.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        onPanelSlide: (double val) => controller.panel.value = val,
        onPanelClosed: () => controller.panelOpen.value = false,
        onPanelOpened: () => controller.panelOpen.value = true,
        controller: controller.panelController,
        parallaxEnabled: true,
        minHeight: kToolbarHeight,
        maxHeight: MediaQuery.of(context).size.height,
        body: BodyWidget(),
        // collapsed: CollapsedWidget(),
        panel: PanelWidget(),
      ),
    );
  }
}
