import 'package:capstone/provider/auth_provider.dart';
import 'package:capstone/ui/auth/login_page.dart';
import 'package:capstone/ui/dashboard_page.dart';
import 'package:capstone/ui/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int _splashScreenDuration = 3;
  final auth = FirebaseAuth.instance;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((event) {
      if(event == null) {
        print("tidak login");
      } else {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
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
    } else {
      moveToRestaurantListPage(HomePage.routeName);

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

  moveToRestaurantListPage(route) {
    Future.delayed(Duration(seconds: _splashScreenDuration)).then((value) {
      Navigator.pushReplacementNamed(context, route);
    });
  }
}
