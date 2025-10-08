// lib/providers/theme_provider.dart

import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Default to system theme preferences
  ThemeMode _themeMode = ThemeMode.system; 

  // Getter
  ThemeMode get themeMode => _themeMode;

  // Action: Toggle between light and dark modes
  void toggleTheme() {
    _themeMode = (_themeMode == ThemeMode.light || _themeMode == ThemeMode.system)
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}