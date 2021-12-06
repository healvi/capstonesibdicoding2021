import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Navigation {
  static intent(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }

  static navigateData(String routeName, Object argument) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: argument);
  }

  static back() => navigatorKey.currentState?.pop();
}
