part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const SETTINGS = _Paths.SETTINGS;
  static const SEARCH = _Paths.SEARCH;
}

abstract class _Paths {
  static const HOME = '/home';
  static const SETTINGS = '/settings';
  static const SEARCH = '/search';
}
