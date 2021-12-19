// import 'package:capstone/data/model/user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// class FirebaseServices {
//   final auth = FirebaseAuth.instance;

//   Future<UserModel> getuser() async {
//     var uid = auth.currentUser!.uid;
//     firebase_storage.FirebaseStorage storage =
//         firebase_storage.FirebaseStorage.instance;
//     DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid");

//     if (uid != null) {
//       var userData = await ref.once();
//       return UserModel.fromJson(userData);
//     } else {
//       throw Exception('Maaf Silahkan Coba Lagi');
//     }
//   }
// }
