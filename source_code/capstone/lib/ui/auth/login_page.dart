import 'package:capstone/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login_page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildList(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          height: 200,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                    hintText: 'Enter Your Email',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 20)),
              ),
              TextField(
                keyboardType: TextInputType.text,
                obscureText: true,
                autofocus: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                    hintText: 'Enter Your Password',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 20)),
              ),
              Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
                    onPressed: () {},
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        actions: [],
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Login'),
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
}
