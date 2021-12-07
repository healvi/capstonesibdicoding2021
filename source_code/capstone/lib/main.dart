import 'package:capstone/common/navigation.dart';
import 'package:capstone/common/styles.dart';
import 'package:capstone/preferences/preferences_helper.dart';
import 'package:capstone/provider/auth_provider.dart';
import 'package:capstone/provider/preferences_provider.dart';
import 'package:capstone/ui/auth/login_page.dart';
import 'package:capstone/ui/auth/signin_page.dart';
import 'package:capstone/ui/event_page.dart';
import 'package:capstone/ui/home_page.dart';
import 'package:capstone/ui/profile_page.dart';
import 'package:capstone/ui/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(email: '', pass: ''),
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
          theme: ThemeData(
            primaryColor: primaryColor,
            accentColor: secondaryColor,
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: myTextTheme,
            appBarTheme: AppBarTheme(
              textTheme: myTextTheme.apply(bodyColor: Colors.black),
              elevation: 0,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: secondaryColor,
              unselectedItemColor: Colors.grey,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: secondaryColor,
                textStyle: TextStyle(),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  ),
                ),
              ),
            ),
          ),
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (context) => const SplashScreen(),
            SignInPage.routeName: (context) => SignInPage(),
            LoginPage.routeName: (context) => LoginPage(),
            HomePage.routeName: (context) => HomePage(),
            EventPage.routeName: (context) => EventPage(),
            ProfilePage.routeName: (context) => ProfilePage(),
          },
        );
      }),
    );
  }
}
