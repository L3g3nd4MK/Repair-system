import 'package:flutter/material.dart';

// Theme for dark mode

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.blue.shade500,
    secondary: Colors.grey.shade700,
    tertiary: Colors.white,
    inversePrimary: Colors.black,
  ),
  textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.grey[300],
        displayColor: Colors.white,
      ),
);
