import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/enums.dart';
import '../utils/shared_pref.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  final SharedPref _sharedPref = SharedPref();

  ThemeViewModel() {
    _loadTheme();
  }

  void _loadTheme() {
    try {
      final themeModeString = _sharedPref.readString(
        SharedPreferencesKeys.themeModeKey.keyText,
      );
      if (themeModeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeModeString,
          orElse: () => ThemeMode.system,
        );
      }
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
    _sharedPref.saveString(
      SharedPreferencesKeys.themeModeKey.keyText,
      themeMode.toString(),
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
