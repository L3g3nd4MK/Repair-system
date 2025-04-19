import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final controller;
  final String label;
  final bool obscureText;
  final IconData? myIcon;
  final bool showPasswordToggle;

  const MyTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.obscureText,
    required this.myIcon,
    this.showPasswordToggle = false,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool isObscure;

  @override
  void initState() {
    super.initState();
    isObscure = widget.obscureText;
  }

  void toggleVisibility() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: TextFormField(
        style: TextStyle(color: Theme.of(context).colorScheme.tertiary,fontFamily: "Mont",),
        controller: widget.controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          label: Text(
            widget.label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold,
              fontFamily: "Mont",
            ),
          ),
          prefixIcon: Icon(
            widget.myIcon,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          suffixIcon: widget.showPasswordToggle
              ? GestureDetector(
                  onTap: toggleVisibility,
                  child: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(22),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}
