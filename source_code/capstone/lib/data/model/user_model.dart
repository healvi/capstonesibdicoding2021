import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserModel {
  String name;
  String images;
  String minat;
  String email;
  List<TugasList> tugaslist;
  UserModel(
      {required this.email,
      required this.name,
      required this.minat,
      required this.images,
      required this.tugaslist});

  factory UserModel.fromData(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'],
      images: data['images'],
      minat: data['minat'],
      name: data['name'],
      tugaslist:
          List<TugasList>.from(data['Tugas'].map((x) => TugasList.fromJson(x))),
    );
  }

  static List<TugasList> parseTugasList(json) {
    List data = json;
    List<TugasList> items = [];
    data.forEach((element) {
      var item = TugasList.fromJson(element);
      items.add(item);
    });
    return items;
  }
}

class TugasList {
  String tugasname;
  String tugasdateline;
  TugasList({required this.tugasname, required this.tugasdateline});

  factory TugasList.fromJson(Map<dynamic, dynamic> parsenJSon) {
    DateTime dta = (parsenJSon['dateline'] as Timestamp).toDate();
    var dt = DateTime.fromMillisecondsSinceEpoch(dta.microsecondsSinceEpoch);
    var d12 = DateFormat('MM/dd/yyyy, hh:mm a').format(dta).toString();
    return TugasList(
        tugasname: parsenJSon['name'], tugasdateline: d12.toString());
  }

  Map<String, dynamic> toJson() => {
        "name": tugasname,
        "dateline": tugasdateline,
      };
}
