import 'package:capstone/provider/user_provider.dart';
import 'package:capstone/utils/auth_result.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  late ResultState _state;
  ResultState get state => _state;

  Future<dynamic> createUser(email, pass, name) async {
    try {
      _state = ResultState.loading;
      final hasil = (await auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      ))
          .user;
      if (auth.currentUser != null) {
        auth.currentUser!.updateDisplayName(name);
      }
      var userUid = hasil!.uid;
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/$userUid");
      ref.set({
        "email": email,
        "name": name,
        "minat": "FLutter",
        "images": "user.png"
      });
      _state = ResultState.Hasdata;
      notifyListeners();
      return _result = AuthResult(user: hasil, message: "success");
    } on FirebaseAuthException catch (e) {
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
      _state = ResultState.Hasdata;
      notifyListeners();
      return _result = AuthResult(user: hasil!, message: "success");
    } on FirebaseAuthException catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return e.toString();
    }
  }

  void signOut() {
    auth.signOut();
  }
}
