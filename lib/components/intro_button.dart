import 'package:flutter/material.dart';

class IntroButton extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  final Color color;

  const IntroButton({super.key, required this.onTap, required this.child, required this.color});

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
        padding: const EdgeInsets.all(30),
        child: child,
      ),
    );
  }
}
