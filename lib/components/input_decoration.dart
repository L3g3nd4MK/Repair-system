import 'package:flutter/material.dart';

class InputStyles {
  // Function to create a common InputDecoration
  static InputDecoration commonInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: "Mont",
        color: Colors.blue,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.blueAccent,
          width: 1.5,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blueAccent,
          width: 2,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blueAccent,
          width: 1.5,
        ),
      ),
    );
  }
}
