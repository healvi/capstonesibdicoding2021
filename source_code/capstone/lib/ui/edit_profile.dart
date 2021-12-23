import 'dart:io';

import 'package:capstone/data/model/user.dart';
import 'package:capstone/data/model/user_model.dart';
import 'package:capstone/provider/auth_provider.dart';
import 'package:capstone/provider/user_provider.dart';
import 'package:capstone/widgets/platform_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfileInPage extends StatefulWidget {
  static const routeName = '/updateProfile_page';
  final UserModel _userDetail;

  EditProfileInPage(this._userDetail);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<EditProfileInPage> {
  final auth = FirebaseAuth.instance;
  late UserProviderFirebase stateProvider;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final picker = ImagePicker();
  String imageUrl = "";
  var url = "";
  final TextEditingController _minatController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _minatController.text = widget._userDetail.minat;
    _nameController.text = widget._userDetail.name;
    imageUrl = widget._userDetail.images;
  }

  Widget _buildRegister(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, state, _) {
      if (auth.currentUser != null) {
        return _buildList(context);
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  Widget _buildList(BuildContext context) {
    return Consumer<UserProviderFirebase>(
      builder: (context, state, _) {
        stateProvider = state;
        return Container(
          color: Colors.white,
          child: Center(
            child: Container(
              height: 450,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Center(
                      child: url.isNotEmpty
                          ? GestureDetector(
                              child: FadeInImage(
                                width: 150,
                                height: 150,
                                placeholder:
                                    const AssetImage('assets/images/user.png'),
                                image: NetworkImage(url),
                                fit: BoxFit.cover,
                              ),
                              onTap: () {
                                _changeFile();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("chang foto prfile"),
                                  duration: Duration(seconds: 1),
                                ));
                              },
                            )
                          : GestureDetector(
                              child: ClipOval(
                                child: FadeInImage(
                                  width: 150,
                                  height: 150,
                                  placeholder: const AssetImage(
                                      'assets/images/user.png'),
                                  image:
                                      NetworkImage(widget._userDetail.images),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              onTap: () {
                                _changeFile();
                              },
                            ),
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    autofocus: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                        hintText: 'Enter Your Name',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20)),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _minatController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                        hintText: 'Enter Your Minat',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIB App'),
        actions: [
          IconButton(
              onPressed: () {
                _updateProfile();
              },
              icon: const Icon(Icons.check, color: Colors.white))
        ],
      ),
      body: _buildRegister(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('SIB App'),
        transitionBetweenRoutes: false,
      ),
      child: _buildRegister(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  void _updateProfile() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("LOADING........"),
      duration: Duration(seconds: 1),
    ));
    var user = Usera(
        email: '',
        name: _nameController.text,
        minat: _minatController.text,
        images: "");
    await stateProvider.updateUser(user);

    Navigator.pop(context);
  }

  void _changeFile() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    firebase_storage.UploadTask uploadTask;
    if (pickedFile != null) {
      File _imageFile = File(pickedFile.path);
      var reslutan = await firebase_storage.FirebaseStorage.instance
          .ref('profile/${auth.currentUser!.uid}-imageprofile')
          .putFile(_imageFile);
      var taskSnapshot = await reslutan.metadata;
      await _getImages(taskSnapshot!.name);
    } else {
      File _imageFile = File(pickedFile!.path);
      var reslutan = await firebase_storage.FirebaseStorage.instance
          .ref('profile/${auth.currentUser!.uid}-imageprofile')
          .putFile(_imageFile);
      var taskSnapshot = await reslutan.metadata;
      await _getImages(taskSnapshot!.name);
    }
  }

  Future<void> _getImages(urls) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("chang foto prfile"),
      duration: Duration(seconds: 5),
    ));
    String images = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile')
        .child("$urls")
        .getDownloadURL();
    var user = Usera(email: '', name: '', minat: '', images: images);
    await stateProvider.updateImage(user);
    setState(() {
      url = images;
    });
  }
}
