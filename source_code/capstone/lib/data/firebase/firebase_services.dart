import 'package:capstone/data/model/user.dart';
import 'package:capstone/data/model/user_model.dart';
import 'package:capstone/data/model/userlist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseServicesa {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  Future<UserModel> getUser(String uid) async {
    final _usersCollectionReference = firestoreInstance.collection("users");
    var userData = await _usersCollectionReference.doc(uid).get();
    return UserModel.fromData(userData.data()!);
  }

  Future<UserModel> updateUser(String uid, Usera user) async {
    final _usersCollectionReference = firestoreInstance.collection("users");
    var update = {
      'name': user.name,
      'minat': user.minat,
    };
    return _usersCollectionReference
        .doc(uid)
        .update(update)
        .then((value) => getUser(uid))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<UserModelList> getUserList() async {
    List<Usera> searchUserResult = [];
    final _usersCollectionReference = firestoreInstance.collection("users");
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    var userData = await _usersCollectionReference.get().then((value) => {
          value.docs.forEach((document) async {
            Usera users = Usera.fromData(document.data());
            String images = await firebase_storage.FirebaseStorage.instance
                .ref()
                .child('profile')
                .child(users.images)
                .getDownloadURL();
            users.images = images;
            searchUserResult.add(users);
          })
        });
    return UserModelList(user: searchUserResult);
  }
}
