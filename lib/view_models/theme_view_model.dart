import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utills/enums.dart';
import '../utills/shared_pref .dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  final SharedPref _sharedPref = SharedPref();

  ThemeViewModel() {
    _loadTheme();
  }

  void _loadTheme() {
    try {
      final themeMode = _sharedPref.readObject(
        SharedPreferencesKeys.themeModeKey.keyText,
      );
      _themeMode = themeMode;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading theme: $e');
      }
      _themeMode = ThemeMode.system; // Default fallback
    }
  }

  void setThemeMode(ThemeMode themeMode) {
    if (_themeMode == themeMode) return;
    _themeMode = themeMode;
    _sharedPref.saveObject(
      SharedPreferencesKeys.themeModeKey.keyText,
      themeMode,
    );
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}
