import 'package:final_app/themes/dark_mode.dart';
import 'package:final_app/themes/light_mode.dart';
import 'package:flutter/material.dart';

// Handle theme changes

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Pass colors for relevant theme
  void toggleTheme(){
    if(_themeData == lightMode){
      themeData = darkMode;
    }else{
      themeData = lightMode;
    }
  }

  // Change the theme based on brightness (dark/light)
  void updateTheme(Brightness brightness){
    if(brightness == Brightness.dark){
      themeData = darkMode;
    }else{
      themeData = lightMode;
    }
  }

}
