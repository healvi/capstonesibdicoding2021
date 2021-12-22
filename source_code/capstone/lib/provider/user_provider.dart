import 'package:capstone/data/firebase/firebase_services.dart';
import 'package:capstone/data/model/user.dart';
import 'package:capstone/data/model/user_model.dart';
import 'package:capstone/data/model/userlist_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

enum ResultState { loading, Nodata, Hasdata, Error }

class UserProviderFirebase extends ChangeNotifier {
  final FirebaseServicesa firebaseServices;
  UserProviderFirebase({required this.firebaseServices}) {
    getUser();
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

  Future<dynamic> getUser() async {
    var uid = auth.currentUser!.uid;

    try {
      _state = ResultState.loading;
      UserModel reslutan = await firebaseServices.getUser(uid);
      // String images = await firebase_storage.FirebaseStorage.instance
      //     .ref()
      //     .child('profile')
      //     .child(reslutan.images)
      //     .getDownloadURL();
      _state = ResultState.Hasdata;
      notifyListeners();
      return resultUser = UserModel(
          email: reslutan.email,
          name: reslutan.name,
          minat: reslutan.minat,
          images: reslutan.images,
          tugaslist: reslutan.tugaslist);
    } on firebase_core.FirebaseException catch (e) {
      _state = ResultState.Error;
      String defaultImage = 'user.png';
      notifyListeners();
      return resultUser = UserModel(
          email: "",
          name: "",
          minat: "",
          images: defaultImage,
          tugaslist: listTugas);
    }
  }

  Future<dynamic> updateUser(Usera user) async {
    var uid = auth.currentUser!.uid;
    try {
      _state = ResultState.loading;
      UserModel reslutan = await firebaseServices.updateUser(uid, user);
      String images = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile')
          .child(reslutan.images)
          .getDownloadURL();
      _state = ResultState.Hasdata;
      notifyListeners();
      return resultUser = UserModel(
          email: reslutan.email,
          name: reslutan.name,
          minat: reslutan.minat,
          images: images,
          tugaslist: reslutan.tugaslist);
    } on firebase_core.FirebaseException catch (e) {
      _state = ResultState.Error;
      String defaultImage = 'user.png';
      notifyListeners();
      return resultUser = UserModel(
          email: "",
          name: "",
          minat: "",
          images: defaultImage,
          tugaslist: listTugas);
    }
  }
}
