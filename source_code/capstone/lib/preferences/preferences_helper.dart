import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const DARK_THEME = 'DARK_THEME';
  static const ISLOGIN = 'ISLOGIN';

  Future<bool> get isDarkTheme async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DARK_THEME) ?? false;
  }

  Future<bool> get isLogin async {
    final prefs = await sharedPreferences;
    return prefs.getBool(ISLOGIN) ?? false;
  }

  void setDarkTheme(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(DARK_THEME, value);
  }

  void setIsLogin(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(ISLOGIN, value);
  }
}
