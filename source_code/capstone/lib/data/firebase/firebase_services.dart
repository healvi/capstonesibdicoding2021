import 'package:capstone/data/model/user.dart';
import 'package:capstone/data/model/user_model.dart';
import 'package:capstone/data/model/userlist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseServicesa {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future<UserModel> getUser(String uid) async {
    final _usersCollectionReference = firestoreInstance.collection("users");
    var userData = await _usersCollectionReference.doc(uid).get();
    return UserModel.fromData(userData.data()!);
  }

  Future<UserModelList> getUserList() async {
    final _usersCollectionReference = firestoreInstance.collection("users");
    var userData = await _usersCollectionReference.get();
    return UserModelList.fromJSON(userData.docs);
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

  Future<dynamic> updateImage(String uid, Usera user) async {
    final _usersCollectionReference = firestoreInstance.collection("users");
    var update = {
      'images': user.images,
    };
    return _usersCollectionReference
        .doc(uid)
        .update(update)
        .then((value) => getUser(uid))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
