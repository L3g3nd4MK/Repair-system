import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_app/pages/login_or_register_page.dart';
import 'package:final_app/pages/admin/unauthorized_access.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../pages/admin/admin_page.dart';
import '../../pages/customer/customer_home_nav.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthPage extends StatelessWidget {

  // Get current user
  User? getCurrentUser(){
    return FirebaseAuth.instance.currentUser;
  }

  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          // User is logged in
          if (authSnapshot.hasData) {
            final User? user = authSnapshot.data;

            // Get user role from firestore
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.hasError) {
                  return Text('Error: ${roleSnapshot.error}');
                }

                // Wait for Firestore data
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Check the users role
                if (roleSnapshot.hasData && roleSnapshot.data != null) {
                  final data = roleSnapshot.data;
                  if (data != null && data.exists) {
                    final role = roleSnapshot.data!.get('role');

                    // If on web && role = admin -> go to admin page
                    if (kIsWeb) {
                      if (role == 'admin') {
                        return AdminPage();
                      } else {
                        return const CustomerHomeNav();
                      }
                      // If on mobile && role = admin -> unauthorized access
                    } else {
                      if (role == 'admin') {
                        FirebaseAuth.instance.signOut().then((_) {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const UnauthorizedAccess()),
                          );
                          });
                      } else {
                        return const CustomerHomeNav();
                      }
                    }
                  }
                }
                // If user not found
                return const LoginOrRegisterPage();
              },
            );
          } else {
            // If user not logged in
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}