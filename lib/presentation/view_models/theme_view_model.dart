import 'package:flutter/material.dart';
import '../../core/constants/enums.dart';
import '../../core/storage/shared_pref.dart';
import '../../core/logging/logger_service.dart';

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
      AppLogger.w('Error loading theme: $e');
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

