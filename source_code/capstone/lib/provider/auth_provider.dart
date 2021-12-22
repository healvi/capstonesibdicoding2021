import 'package:capstone/provider/user_provider.dart';
import 'package:capstone/utils/auth_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  late ResultState _state;
  ResultState get state => _state;

  Future<dynamic> createUser(email, pass, name) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
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
      var timestamp = DateTime(2022, 9, 7, 17, 30);
      var userUid = hasil!.uid;

      String images = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile')
          .child("user.png")
          .getDownloadURL();
      notifyListeners();

      firestoreInstance.collection("users").doc(userUid).set({
        "name": name,
        "email": email,
        "minat": "FLutter",
        "images": images,
        "Tugas": [
          {"name": "tugas 1", "dateline": Timestamp.fromDate(timestamp)},
          {"name": "tugas 2", "dateline": Timestamp.fromDate(timestamp)}
        ]
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
