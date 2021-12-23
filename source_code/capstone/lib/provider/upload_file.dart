import 'dart:io';

import 'package:capstone/data/firebase/firebase_services.dart';
import 'package:capstone/provider/image_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadFile extends ChangeNotifier {
  final FirebaseServicesa firebaseServices;
  late final File _file;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  UploadFile({required this.firebaseServices}) {
    uploadImage(_file);
  }
  late ResultState _state;
  final auth = FirebaseAuth.instance;
  ResultState get state => _state;

  Future<dynamic> uploadImage(file) async {
    var uid = auth.currentUser!.uid;
    var url = "";
    try {
      _state = ResultState.loading;
      var reslutan = await firebase_storage.FirebaseStorage.instance
          .ref('profile/$uid-imageprofile')
          .putFile(file);
      reslutan.ref.getDownloadURL().then(
            (value) => url = value,
          );
      _state = ResultState.Hasdata;
      notifyListeners();
      return "";
    } on firebase_core.FirebaseException catch (e) {
      _state = ResultState.Error;
      String defaultImage = 'user.png';
      notifyListeners();
      return "";
    }
  }
}
