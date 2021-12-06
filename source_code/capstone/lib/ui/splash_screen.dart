import 'package:capstone/ui/auth/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const routeName = '/splash_screen';
  final int _splashScreenDuration = 3;

  @override
  Widget build(BuildContext context) {
    moveToRestaurantListPage() {
      Future.delayed(Duration(seconds: _splashScreenDuration)).then((value) {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      });
    }

    moveToRestaurantListPage();

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
