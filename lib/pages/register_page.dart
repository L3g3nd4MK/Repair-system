import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_app/pages/customer/customer_home_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_app/components/my_button.dart';
import 'package:final_app/components/my_textfield.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Text-editing controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? phoneNumber;

  // Method to check if full name contains only letters and spaces
  bool isFullNameValid(String fullName) {
    final nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
    return nameRegExp.hasMatch(fullName);
  }

  // Method to check if email is valid
  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  // Method to check if password is secure
  bool isPasswordStrong(String password) {
    final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  // Register user method
  void signUserUp() async {
    // Check if any fields are empty
    if (fullNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        phoneNumber == null ||
        phoneNumber!.isEmpty) {
      showErrorMessage("All fields are required!");
      return;
    }

    // Check if full name is valid
    if (!isFullNameValid(fullNameController.text.trim())) {
      showErrorMessage("Full name should only contain letters and spaces!");
      return;
    }

    // Check if email is valid
    if (!isEmailValid(emailController.text.trim())) {
      showErrorMessage("Please enter a valid email address!");
      return;
    }

    // Check if password is strong
    if (!isPasswordStrong(passwordController.text)) {
      showErrorMessage(
          "Password must be at least 8 characters and contain letters and numbers.");
      return;
    }

    // Show loading icon
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // Try creating the user
    try {
      // Check if password matches confirmation field
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        // Store user info in a separate doc for messaging
        _firestore.collection("chats").doc(userCredential.user!.uid).set(
          {
            'uid': userCredential.user!.uid,
            'email': emailController.text.trim(),
            'role': 'customer',
          },
        );

        // Get user id
        String uid = userCredential.user!.uid;

        // Pop loading icon + save customer details in Firestore
        if (mounted) {
          Navigator.pop(context);
        }

          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'role': 'customer',
            'fullName': fullNameController.text.trim(),
            'email': emailController.text.trim(),
            'phone': phoneNumber,
          });

          // Navigate to Homepage if successful
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CustomerHomeNav()),
          );
        }
      } else {
        // Pop loading icon + show error message, passwords don't match
        if (mounted) {
          Navigator.pop(context);
          showErrorMessage("Passwords do not match!");
        }
      }
    } on FirebaseAuthException catch (e) {
      // Pop loading icon + show error message
      if (mounted) {
        Navigator.pop(context);
        showErrorMessage(e.code);
      }
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
      backgroundColor: Theme.of(context).colorScheme.primary,
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
            // Show background image behind container
            const Expanded(
              flex: 1,
              child: SizedBox(
                height: 10,
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 5),

                          // Logo
                          Icon(Icons.shopping_bag,
                              size: 80,
                              color: Theme.of(context).colorScheme.primary),

                          const SizedBox(height: 5),

                          // Register Message
                          Text(
                            "Let's create you an account!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                              fontFamily: "Mont",
                            ),
                          ),

                          // Full name text field
                          MyTextField(
                            controller: fullNameController,
                            label: 'Full Name',
                            obscureText: false,
                            myIcon: Icons.person_outline,
                          ),

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

                          // Confirm password text field
                          MyTextField(
                            controller: confirmPasswordController,
                            label: 'Confirm Password',
                            obscureText: true,
                            myIcon: Icons.lock_outline,
                            showPasswordToggle: true,
                          ),

                          const SizedBox(height: 5),

                          // Phone Field
                          IntlPhoneField(
                            controller:
                                TextEditingController(text: phoneNumber),
                            initialCountryCode: 'ZA',
                            decoration: InputDecoration(
                              constraints: const BoxConstraints(maxWidth: 350),
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontFamily: "Mont",
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (phone) {
                              phoneNumber = phone.completeNumber;
                            },
                          ),

                          const SizedBox(height: 10),

                          // SignUp button
                          MyButton(
                            color: Theme.of(context).colorScheme.primary,
                            onTap: signUserUp,
                            child: const Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Mont",
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Already a member? Login here
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Mont",
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: widget.onTap,
                                child: Text(
                                  'Login here',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Mont",
                                  ),
                                ),
                              ),
                            ],
                          ),
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
