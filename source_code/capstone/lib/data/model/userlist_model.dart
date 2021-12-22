import 'package:capstone/data/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserModelList {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  List<Usera> user;
  UserModelList({required this.user});

  factory UserModelList.fromJSON(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> json) {
    return UserModelList(user: parseruser(json));
  }
  static List<Usera> parseruser(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> userSON) {
    List<Usera> searchUserResult = [];
    userSON.forEach((document) async {
      Usera users = Usera.fromData(document.data());
      String images = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile')
          .child(users.images)
          .getDownloadURL();
      print("samapai sini");
      users.images = images;
      searchUserResult.add(users);
    });
    return searchUserResult;
  }
}
