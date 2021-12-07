import 'package:capstone/utils/auth_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ResultState { loading, Nodata, Hasdata, Error }

class AuthProvider extends ChangeNotifier {
  late final String email;
  late final String pass;

  AuthProvider({required this.email, required this.pass}) {
    createUser(email, pass);
    loginUser(email, pass);
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLogin = false;
  late ResultState _state;
  ResultState get state => _state;

  Future<dynamic> createUser(email, pass) async {
    try {
      _state = ResultState.loading;
      AuthResult result = (await auth.createUserWithEmailAndPassword(
          email: email, password: pass)) as AuthResult;
      _isLogin = true;
      _state = ResultState.Hasdata;
      notifyListeners();
      return AuthResult(result.user, "success");
    } on FirebaseAuthException catch (e) {
      _isLogin = false;
      _state = ResultState.Error;
      notifyListeners();
      return e.toString();
    }
  }

  Future<dynamic> loginUser(email, pass) async {
    try {
      _state = ResultState.loading;
      AuthResult result = (await auth.signInWithEmailAndPassword(
          email: email, password: pass)) as AuthResult;
      _isLogin = true;
      _state = ResultState.Hasdata;
      notifyListeners();
      return AuthResult(result.user, "success");
    } on FirebaseAuthException catch (e) {
      _isLogin = false;
      _state = ResultState.Error;
      notifyListeners();
      return e.toString();
    }
  }

  void signOut() {
    auth.signOut();
    _isLogin = false;
  }
}
