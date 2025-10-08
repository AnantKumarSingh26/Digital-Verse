// lib/providers/theme_provider.dart

import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Use ThemeMode.system as the initial state
  ThemeMode _themeMode = ThemeMode.system; 

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    // 1. Check current state and toggle to the opposite
    if (_themeMode == ThemeMode.light || _themeMode == ThemeMode.system) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    
    // 2. Notify all listening widgets (i.e., MaterialApp in main.dart) to rebuild
    notifyListeners();
  }
}