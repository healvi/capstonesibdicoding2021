import 'package:capstone/common/navigation.dart';
import 'package:capstone/provider/auth_provider.dart';
import 'package:capstone/ui/auth/signin_page.dart';
import 'package:capstone/ui/dashboard_page.dart';
import 'package:capstone/ui/home_page.dart';
import 'package:capstone/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login_page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword = true;

  late AuthProvider stateProvider;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  void _togglevisibillity() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildLogin(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, state, _) {
      stateProvider = state;
      if (state.state == ResultState.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.state == ResultState.Hasdata) {
        return _toDashboard(context, state.isLogin);
      } else if (state.state == ResultState.Nodata) {
        return _buildPage(context);
      } else if (state.state == ResultState.Error) {
        return _buildPage(context);
      } else {
        return _buildPage(context);
      }
    });
  }

  Widget _toDashboard(BuildContext context, bool isLogin) {
    final int _delay = 1;
    moveDashboard() {
      Future.delayed(Duration(seconds: _delay)).then((value) {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      });
    }

    moveDashboard();

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildPage(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          height: 250,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextField(
                controller: _emailController,
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
                controller: _passwordController,
                keyboardType: TextInputType.text,
                obscureText: _showPassword,
                autofocus: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                    hintText: 'Enter Your Password',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _togglevisibillity();
                      },
                      child: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.blueAccent),
                    ),
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
                    onPressed: () {
                      _login();
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
              Container(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigation.intent(SignInPage.routeName);
                    },
                    child: Text(
                      "Belum daftar",
                      style: TextStyle(color: Colors.black),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: [],
      ),
      body: _buildLogin(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Login'),
        transitionBetweenRoutes: false,
      ),
      child: _buildLogin(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  void _login() {
    var order = stateProvider.loginUser(
        _emailController.text, _passwordController.text);
    print(order);
  }
}

      // showDialog(
      //                   context: context,
      //                   builder: (context) => AlertDialog(
      //                     title: Text("Error"),
      //                     content: Text(result.message),
      //                     actions: <Widget>[
      //                       FlatButton(
      //                         onPressed: () {
      //                           Navigator.pop(context);
      //                         },
      //                         child: Text("OK"),
      //                       )
      //                     ],
      //                   ));