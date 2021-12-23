import 'dart:io';

import 'package:capstone/common/navigation.dart';
import 'package:capstone/data/model/user.dart';
import 'package:capstone/data/model/user_model.dart';
import 'package:capstone/provider/auth_provider.dart';
import 'package:capstone/provider/user_provider.dart';
import 'package:capstone/ui/auth/login_page.dart';
import 'package:capstone/ui/edit_profile.dart';
import 'package:capstone/ui/settings_page.dart';
import 'package:capstone/widgets/platform_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile_page';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  late UserProviderFirebase stateProvider;
  final picker = ImagePicker();

  var url = "";
  @override
  void initState() {
    super.initState();
  }

  Widget _buildList(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, state, _) {
      if (auth.currentUser != null) {
        return _dasboardPage(
          context,
          auth.currentUser!.uid,
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  Widget _dasboardPage(BuildContext context, String uid) {
    return Consumer<UserProviderFirebase>(builder: (context, state, _) {
      if (state.state == ResultState.loading) {
        return _displayUserDummy(context);
      } else if (state.state == ResultState.Hasdata) {
        UserModel user = state.resultUser;
        return _displayUserFirebase(context, user, url.isNotEmpty);
      } else if (state.state == ResultState.Nodata) {
        return _displayUserDummy(context);
      } else if (state.state == ResultState.Error) {
        return _displayUserDummy(context);
      } else {
        return _displayUserDummy(context);
      }
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIB App'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SettingsPage();
                }));
              },
              icon: const Icon(Icons.settings, color: Colors.white)),
          IconButton(
              onPressed: () {
                _logout();
              },
              icon: const Icon(Icons.power_off, color: Colors.red))
        ],
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('SIB App'),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  void _logout() async {
    await auth.signOut().then((value) => {
          Navigator.pushNamedAndRemoveUntil(
              context, LoginPage.routeName, (route) => false)
        });
  }

  Widget _displayUserFirebase(
      BuildContext context, UserModel user, bool imagesLokal) {
    return Consumer<UserProviderFirebase>(
      builder: (context, state, _) {
        stateProvider = state;
        return SafeArea(
          child: Material(
            child: Container(
              color: Colors.blue[100],
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 4.0),
                      height: 300.0,
                      color: Colors.blue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: imagesLokal
                                ? GestureDetector(
                                    child: FadeInImage(
                                      width: 150,
                                      height: 150,
                                      placeholder: const AssetImage(
                                          'assets/images/user.png'),
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
                                    child: FadeInImage(
                                      width: 150,
                                      height: 150,
                                      placeholder: const AssetImage(
                                          'assets/images/user.png'),
                                      image: NetworkImage(user.images),
                                      fit: BoxFit.cover,
                                    ),
                                    onTap: () {
                                      _changeFile();
                                    },
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Text(user.name.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 12, right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 20)),
                                    onPressed: () {
                                      Navigation.navigateData(
                                          EditProfileInPage.routeName, user);
                                    },
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                    ),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(top: 12),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 20)),
                                    onPressed: () {},
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Bantuan",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ))
                  ]),
            ),
          ),
        );
      },
    );
  }

  Widget _displayUserDummy(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
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
