import 'package:capstone/ui/auth/login_page.dart';
import 'package:capstone/ui/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int _splashScreenDuration = 3;

  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    isLoginyes();
    if (isLogin) {
      moveToRestaurantListPage(DashboardPage.routeName);
      return Scaffold(
          backgroundColor: Colors.blue,
          body: Center(
            child: Container(
              width: 500,
              height: 500,
              child: Image.asset("assets/images/sibbrand.png"),
            ),
          ));
    } else {
      moveToRestaurantListPage(LoginPage.routeName);
      return Scaffold(
          backgroundColor: Colors.blue,
          body: Center(
            child: Container(
              width: 500,
              height: 500,
              child: Image.asset("assets/images/sibbrand.png"),
            ),
          ));
    }
  }

  void isLoginyes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogin = prefs.getBool("ISLOGIN") ?? false;
    });
  }

  moveToRestaurantListPage(route) {
    Future.delayed(Duration(seconds: _splashScreenDuration)).then((value) {
      Navigator.pushReplacementNamed(context, route);
    });
  }
}
