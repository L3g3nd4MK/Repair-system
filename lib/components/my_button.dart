import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  final Color color;

  const MyButton({super.key, required this.onTap, required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(90),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: child,
      ),
    );
  }
}
