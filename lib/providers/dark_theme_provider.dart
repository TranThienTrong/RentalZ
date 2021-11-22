import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemeProvider with ChangeNotifier {
  static const THEME_STATUS = "THEME_STATUS";
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  setDarkTheme(bool value) async {
    _isDarkTheme = value;
    print("Is Dark Them $_isDarkTheme");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
    notifyListeners();
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) == null
        ? false
        : prefs.getBool(THEME_STATUS)!;
  }
}
