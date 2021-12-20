import 'package:capstone/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';

enum ResultState { loading, Nodata, Hasdata, Error }

class ImageProviderFirebase extends ChangeNotifier {
  late final String url;
  ImageProviderFirebase({required this.url}) {
    getUser(url);
  }
  final auth = FirebaseAuth.instance;
  late UserModel resultUser;
  UserModel get result => resultUser;
  late ResultState _state;
  ResultState get state => _state;

  Future<dynamic> getUser(url) async {
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    var firebaseUser = FirebaseAuth.instance.currentUser;
    try {
      _state = ResultState.loading;
      String images = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile')
          .child("$url")
          .getDownloadURL();
      notifyListeners();
      return images;
    } on firebase_core.FirebaseException catch (e) {
      _state = ResultState.Error;
      String defaultImage = 'user.png';
      String images = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile')
          .child("$defaultImage ")
          .getDownloadURL();

      notifyListeners();
      return images;
    }
  }
}
