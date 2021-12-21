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
        UserModelList user = state.resultUserList;
        return _displayUserFirebase(context, user);
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
    return SafeArea(
      child: Material(
        child: Container(
            padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
            color: Colors.blue[100],
            child: Expanded(
                flex: 1,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(user.user[index].name),
                          duration: Duration(seconds: 1),
                        ));
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
                                padding:
                                    EdgeInsets.only(left: 16.0, right: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                ))),
      ),
    );
  }

  Widget _displayUserDummy(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
