import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_app/components/my_button.dart';
import 'package:final_app/components/my_textfield.dart';
import 'forgot_pw_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Text-editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign user in method
  void signUserIn() async {
    // Verify all fields are filled
    if(emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty){
      showErrorMessage("All fields are required!");
      return;
    }

    // Show loading icon
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // Try sign in
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      // Store user info in a separate doc for messaging feature
      _firestore.collection("chats").doc(userCredential.user!.uid).update(
        {
          'uid': userCredential.user!.uid, 'email': emailController.text.trim(),
        },
      );
      // Pop the loading icon
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Pop the loading icon
      Navigator.pop(context);
      // Show error message
      showErrorMessage(e.code);
    }
  }

  // Show error to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('lib/assets/home_bg.jpeg'),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            // show background
            const Expanded(
              flex: 1,
              child: SizedBox(
                height: 10,
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                decoration:  BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  boxShadow: const [BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                    offset: Offset(0, 5),
                  )],
                ),
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          //logo
                          Icon(
                            Icons.shopping_bag,
                            size: 100,
                            color: Theme.of(context).colorScheme.primary,
                          ),

                          // Welcome back message
                          Text(
                            "Welcome back, you've been missed!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: "Mont",
                              color:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Email text field
                          MyTextField(
                            controller: emailController,
                            label: 'Email',
                            obscureText: false,
                            myIcon: Icons.email_outlined,
                          ),

                          // Password text field
                          MyTextField(
                            controller: passwordController,
                            label: 'Password',
                            obscureText: true,
                            myIcon: Icons.lock_outline,
                            showPasswordToggle: true,
                          ),

                          // Forgot password
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const ForgotPasswordPage();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                        fontFamily: "Mont"
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          // SignIn button
                          MyButton(
                            color: Theme.of(context).colorScheme.primary,
                            onTap: signUserIn,
                            child: const Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Mont",
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Not a member? signUp here -> register_page
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Not a member?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                    fontFamily: "Mont",
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: widget.onTap,
                                child: Text(
                                  'Register here',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontFamily: "Mont",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
