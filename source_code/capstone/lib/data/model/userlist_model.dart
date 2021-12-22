import 'package:capstone/data/model/user.dart';

class UserModelList {
  List<Usera> user;
  UserModelList({required this.user});

  factory UserModelList.fromJSON(Map<dynamic, dynamic> json) {
    return UserModelList(user: parseruser(json));
    // user: List<User>.from(json.map((x) => User.fromData(x))),
  }
  static List<Usera> parseruser(userSON) {
    print(userSON);
    var rList = userSON;
    List<Usera> recipeList = rList.map((data) => Usera.fromData(data)).toList();
    return recipeList; //And this
  }
}
