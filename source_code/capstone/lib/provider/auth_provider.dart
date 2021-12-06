import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLogin = false;
  void _getLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        _isLogin = false;
        notifyListeners();
      } else {
        print('User is signed in!');
        _isLogin = true;
        notifyListeners();
      }
    });
  }
}
