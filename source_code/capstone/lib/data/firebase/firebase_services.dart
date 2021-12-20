import 'package:capstone/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServicesa {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  Future<UserModel> getUser(String uid) async {
    final _usersCollectionReference = firestoreInstance.collection("users");
    var userData = await _usersCollectionReference.doc(uid).get();
    return UserModel.fromData(userData.data()!);
  }
}
