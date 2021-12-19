import 'dart:convert';

class UserModel {
  String name;
  String images;
  String minat;
  String email;
  // List<TugasList> tugaslist;
  UserModel({
    required this.email,
    required this.name,
    required this.minat,
    required this.images,
    // required this.tugaslist
  });
}

class TugasList {
  String tugasname;
  String tugasdateline;
  TugasList({required this.tugasname, required this.tugasdateline});

  factory TugasList.fromRawJson(String str) =>
      TugasList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TugasList.fromJson(Map<String, dynamic> json) => TugasList(
        tugasname: json["id"],
        tugasdateline: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": tugasname,
        "dateline": tugasdateline,
      };
}
