import 'package:get/get.dart';

import 'package:ruminate/app/modules/home/bindings/home_binding.dart';
import 'package:ruminate/app/modules/home/views/home_view.dart';
import 'package:ruminate/app/modules/search/bindings/search_binding.dart';
import 'package:ruminate/app/modules/search/views/search_view.dart';
import 'package:ruminate/app/modules/settings/bindings/settings_binding.dart';
import 'package:ruminate/app/modules/settings/views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
  ];
}
