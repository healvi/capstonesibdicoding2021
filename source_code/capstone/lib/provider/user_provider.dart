import 'dart:convert';

import 'package:capstone/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

enum ResultState { loading, Nodata, Hasdata, Error }

class UserProviderFirebase extends ChangeNotifier {
  UserProviderFirebase() {
    getUser();
  }

  late final String url;
  final auth = FirebaseAuth.instance;
  late UserModel resultUser;
  UserModel get result => resultUser;
  late ResultState _state;
  ResultState get state => _state;

  Future<dynamic> getUser() async {
    var uid = auth.currentUser!.uid;
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid");
    try {
      _state = ResultState.loading;
      DatabaseEvent name = await ref.child("name").once();
      DatabaseEvent minat = await ref.child("minat").once();
      DatabaseEvent email = await ref.child("email").once();
      DatabaseEvent image = await ref.child("images").once();
      DatabaseEvent tugas = await ref.child("tugas").once();

      var imageUrl = image.snapshot.value;
      Object? tugasResponse = tugas.snapshot.value;

      String names = name.snapshot.value.toString();
      String minats = minat.snapshot.value.toString();
      String emails = email.snapshot.value.toString();
      String images = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile')
          .child("$imageUrl")
          .getDownloadURL();
      _state = ResultState.Hasdata;
      notifyListeners();
      return resultUser = UserModel(
        email: emails,
        name: names,
        minat: minats,
        images: images,
        // tugaslist: tugasResponse
      );
    } on firebase_core.FirebaseException catch (e) {
      _state = ResultState.Error;
      String defaultImage = 'user.png';
      notifyListeners();
      return "";
    }
  }
}
