import 'package:capstone/provider/auth_provider.dart';
import 'package:capstone/ui/home_page.dart';
import 'package:capstone/ui/settings_page.dart';
import 'package:capstone/utils/result.dart';
import 'package:capstone/widgets/platform_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/sign_page';
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _showPassword = true;
  final auth = FirebaseAuth.instance;
  late AuthProvider stateProvider;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  void _togglevisibillity() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildRegister(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, state, _) {
      stateProvider = state;
      if (auth.currentUser != null) {
        return _toDashboard(context);
      } else {
        if (state.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.Hasdata) {
          return _toDashboard(context);
        } else if (state.state == ResultState.Nodata) {
          return _buildList(context);
        } else if (state.state == ResultState.Error) {
          return _buildList(context);
        } else {
          return _buildList(context);
        }
      }
    });
  }

  Widget _toDashboard(BuildContext context) {
    final int _delay = 1;
    moveDashboard() {
      Future.delayed(Duration(seconds: _delay)).then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (route) => false);
      });
    }

    moveDashboard();
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList(BuildContext context) {
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
                      _register();
                    },
                    child: Text(
                      "Sign In",
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
        title: const Text('SIB App'),
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

  void _register() {
    var order = stateProvider.createUser(
        _emailController.text, _passwordController.text, _nameController.text);
  }
}
