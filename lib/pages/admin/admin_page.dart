import 'package:final_app/components/my_button.dart';
import 'package:final_app/pages/admin/admin_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  AdminPage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  //sign user out method
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
        title: const Text('Admin Page'),
      ),
      body: Center(
        child: MyButton(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminMessagesPage()),
          ),
          color: Colors.blue,
          child: const Padding(
            padding: EdgeInsets.all(25.0),
            child: (Text(
              "Go to Messages",
              style: TextStyle(fontSize: 16),
            )),
          ),
        ),
      ),
    );
  }
}
