import 'package:final_app/components/intro_button.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                // Set background image
                image: DecorationImage(
              image: AssetImage('lib/assets/home_bg.jpeg'),
              fit: BoxFit.cover,
            )),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                  Icon(
                    Icons.shopping_bag,
                    size: 95,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(height: 10),

                  // Title
                  Text(
                    "Welcome to Matrix!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: "Mont",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Navigation Button
                  IntroButton(
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () => Navigator.pushNamed(context, '/auth_page'),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )));
  }
}
