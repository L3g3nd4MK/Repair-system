import 'package:flutter/material.dart';

// Theme for light mode

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.blue[900]!,
    secondary: Colors.grey.shade400,
    tertiary: Colors.black,
    inversePrimary: Colors.white,
  ),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.grey[800],
    displayColor: Colors.black,
  ),
);