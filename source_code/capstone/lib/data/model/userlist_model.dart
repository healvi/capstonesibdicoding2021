class UserModelList {
  List<User> user;
  UserModelList({required this.user});

  factory UserModelList.fromJSON(Map<dynamic, dynamic> json) {
    return UserModelList(user: parseruser(json));
    // user: List<User>.from(json.map((x) => User.fromData(x))),
  }
  static List<User> parseruser(userSON) {
    print(userSON);
    var rList = userSON;
    List<User> recipeList = rList.map((data) => User.fromData(data)).toList();
    return recipeList; //And this
  }
}

class User {
  String name;
  String images;
  String minat;
  String email;

  User({
    required this.email,
    required this.name,
    required this.minat,
    required this.images,
  });

  factory User.fromData(Map<String, dynamic> data) {
    return User(
      email: data['email'],
      images: data['images'],
      minat: data['minat'],
      name: data['name'],
    );
  }
}
