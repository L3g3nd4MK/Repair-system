import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final String string;
  final Widget? widget;
  const MyContainer({super.key, required this.string, this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
    padding: const EdgeInsets.all(25),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        string,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      widget ?? Container(),
      ],
    ),
    );
  }
}
