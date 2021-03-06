import 'package:capstone/data/model/user.dart';
import 'package:capstone/data/model/user_model.dart';
import 'package:capstone/data/model/userlist_model.dart';
import 'package:capstone/provider/auth_provider.dart';
import 'package:capstone/provider/image_provider.dart';
import 'package:capstone/provider/user_provider_list.dart';
import 'package:capstone/ui/settings_page.dart';
import 'package:capstone/widgets/platform_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  static const routeName = '/event_page';

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool _showPassword = true;

  void _togglevisibillity() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  final auth = FirebaseAuth.instance;
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
    return Consumer<UserProviderListFirebase>(builder: (context, state, _) {
      if (state.state == ResultState.loading) {
        return _displayUserDummy(context);
      } else if (state.state == ResultState.Hasdata) {
        return _displayUserFirebase(context, state.resultUserList);
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
        title: Text('SIB App'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SettingsPage();
                }));
              },
              icon: const Icon(Icons.settings, color: Colors.white))
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

  Widget _displayUserFirebase(BuildContext context, UserModelList user) {
    print(" data dsplay ${user.user}");
    return SafeArea(
      child: Material(
        child: Container(
            padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
            color: Colors.blue[100],
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _showModal(context, user.user[index] as Usera);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 8, right: 8, top: 4.0),
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          FadeInImage(
                            width: 40,
                            height: 40,
                            placeholder:
                                const AssetImage('assets/images/user.png'),
                            image: NetworkImage(user.user[index].images),
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '${user.user[index].name.toUpperCase()}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '${user.user[index].minat.toUpperCase()}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
                );
              },
              itemCount: user.user.length,
            )),
      ),
    );
  }

  Widget _displayUserDummy(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  void _showModal(BuildContext context, Usera user) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.blue[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    alignment: Alignment.topRight,
                    margin: const EdgeInsets.only(top: 35, left: 15),
                    child: RawMaterialButton(
                      child: Icon(
                          const IconData(0xe16a, fontFamily: 'MaterialIcons'),
                          color: Colors.white),
                      fillColor: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.all(0),
                      shape: CircleBorder(),
                    )),
                Center(
                  child: FadeInImage(
                    width: 150,
                    height: 150,
                    placeholder: const AssetImage('assets/images/user.png'),
                    image: NetworkImage(user.images),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("NAME",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          )),
                      Container(
                          color: Colors.white,
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 5),
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20),
                          child: Text(user.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ))),
                      Text("MINAT",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          )),
                      Container(
                          color: Colors.white,
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 5),
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20),
                          child: Text(user.minat.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ))),
                      Text("EMAIL",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          )),
                      Container(
                          color: Colors.white,
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 5),
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20),
                          child: Text(user.email.toLowerCase(),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ))),
                    ],
                  )),
                ),
              ],
            ),
          );
        });
  }
}
