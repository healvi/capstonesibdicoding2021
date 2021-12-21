import 'package:capstone/data/firebase/firebase_services.dart';
import 'package:capstone/data/model/user_model.dart';
import 'package:capstone/data/model/userlist_model.dart';
import 'package:capstone/provider/image_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProviderListFirebase extends ChangeNotifier {
  final FirebaseServicesa firebaseServices;
  UserProviderListFirebase({required this.firebaseServices}) {
    getUserList();
  }

  late final String url;
  final auth = FirebaseAuth.instance;
  late UserModel resultUser;
  UserModel get result => resultUser;

  late UserModelList resultUserList;
  UserModelList get resultList => resultUserList;
  late ResultState _state;
  ResultState get state => _state;
  List<TugasList> listTugas = [];

  Future<dynamic> getUserList() async {
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var uid = auth.currentUser!.uid;
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    var firebaseUser = FirebaseAuth.instance.currentUser;

    try {
      _state = ResultState.loading;
      UserModelList resultan = await firebaseServices.getUserList();
      _state = ResultState.Hasdata;
      notifyListeners();
      return resultUserList = resultan;
    } on firebase_core.FirebaseException catch (e) {
      _state = ResultState.Error;
      String defaultImage = 'user.png';
      notifyListeners();
      return "";
    }
  }
}
