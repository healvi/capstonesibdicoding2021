import 'package:capstone/data/model/user_model.dart';
import 'package:capstone/provider/auth_provider.dart';
import 'package:capstone/provider/user_provider.dart';
import 'package:capstone/ui/settings_page.dart';
import 'package:capstone/widgets/platform_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  static const routeName = '/dashboard_page';
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
    return Consumer<UserProviderFirebase>(builder: (context, state, _) {
      if (state.state == ResultState.loading) {
        return _displayUserDummy(context);
      } else if (state.state == ResultState.Hasdata) {
        UserModel user = state.resultUser;
        return _displayUserFirebase(context, user);
        // return _displayUserDummy(context);
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

  Widget _displayUserFirebase(BuildContext context, UserModel user) {
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
                        child: ClipOval(
                          child: FadeInImage(
                            width: 150,
                            height: 150,
                            placeholder:
                                const AssetImage('assets/images/user.png'),
                            image: NetworkImage(user.images),
                            fit: BoxFit.cover,
                          ),
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
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(left: 8, right: 8, top: 4.0),
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blueAccent),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${user.tugaslist[index].tugasname}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${user.tugaslist[index].tugasdateline}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ]),
                        );
                      },
                      itemCount: user.tugaslist.length,
                    ))
              ]),
        ),
      ),
    );
  }

  Widget _displayUserDummy(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
