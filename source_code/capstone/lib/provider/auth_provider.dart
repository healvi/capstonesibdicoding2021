import 'package:capstone/utils/auth_result.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ResultState { loading, Nodata, Hasdata, Error }

class AuthProvider extends ChangeNotifier {
  late final String email;
  late final String pass;
  late final String name;

  AuthProvider({required this.email, required this.pass, required this.name}) {
    createUser(email, pass, name);
    loginUser(email, pass);
  }

  late AuthResult _result;
  AuthResult get result => _result;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLogin = false;
  late ResultState _state;
  ResultState get state => _state;

  Future<dynamic> createUser(email, pass, name) async {
    try {
      _state = ResultState.loading;
      final hasil = (await auth.createUserWithEmailAndPassword(
              email: email, password: pass))
          .user;
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      ref
          .child("users")
          .push()
          .set({"name": name, "Minat": "FLutter", "images": "user.png"});
      isLogin = true;
      isLoginyes();
      _state = ResultState.Hasdata;
      notifyListeners();
      return AuthResult(user: hasil!, message: "success");
    } on FirebaseAuthException catch (e) {
      isLogin = false;
      _state = ResultState.Error;
      notifyListeners();
      return e.toString();
    }
  }

  Future<dynamic> loginUser(email, pass) async {
    try {
      _state = ResultState.loading;
      final hasil =
          (await auth.signInWithEmailAndPassword(email: email, password: pass))
              .user;

      isLogin = true;
      isLoginyes();
      _state = ResultState.Hasdata;
      notifyListeners();
      return AuthResult(user: hasil!, message: "success");
    } on FirebaseAuthException catch (e) {
      isLogin = false;
      _state = ResultState.Error;
      notifyListeners();
      return e.toString();
    }
  }

  void signOut() {
    auth.signOut();
    isLogin = false;
    isLoginyes();
  }

  void isLoginyes() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("ISLOGIN", isLogin);
    prefs.setString("email", email);
    prefs.setString("pass", pass);
  }
}
