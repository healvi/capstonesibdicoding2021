import 'package:capstone/common/navigation.dart';
import 'package:capstone/data/firebase/firebase_services.dart';
import 'package:capstone/preferences/preferences_helper.dart';
import 'package:capstone/provider/auth_provider.dart';
import 'package:capstone/provider/user_provider.dart';
import 'package:capstone/provider/preferences_provider.dart';
import 'package:capstone/ui/auth/login_page.dart';
import 'package:capstone/ui/auth/signin_page.dart';
import 'package:capstone/ui/event_page.dart';
import 'package:capstone/ui/home_page.dart';
import 'package:capstone/ui/profile_page.dart';
import 'package:capstone/ui/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  late AuthProvider stateProvider;
  String email = '';
  String pass = "";
  String name = "";
  @override
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        print("tidak login");
      } else {
        print(event);
      }
    });
  }

  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(email: email, pass: pass, name: name),
          ),
          ChangeNotifierProvider(
            create: (_) =>
                UserProviderFirebase(firebaseServices: FirebaseServicesa()),
          ),
          ChangeNotifierProvider(
            create: (_) => PreferencesProvider(
              preferencesHelper: PreferencesHelper(
                sharedPreferences: SharedPreferences.getInstance(),
              ),
            ),
          ),
        ],
        child: Consumer<PreferencesProvider>(builder: (context, value, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'SIB App',
            theme: value.themeData,
            initialRoute: SplashScreen.routeName,
            routes: {
              SplashScreen.routeName: (context) => SplashScreen(),
              SignInPage.routeName: (context) => SignInPage(),
              LoginPage.routeName: (context) => LoginPage(),
              HomePage.routeName: (context) => HomePage(),
              EventPage.routeName: (context) => EventPage(),
              ProfilePage.routeName: (context) => ProfilePage(),
            },
          );
        }));
  }
}
