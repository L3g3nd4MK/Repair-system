import 'package:flutter/material.dart';
import 'package:final_app/services/chat/chat_service.dart';
import '../../components/user_tile.dart';
import '../../services/auth/auth_page.dart';
import '../chat_page.dart';

class AdminMessagesPage extends StatelessWidget {
  final ChatService _chatService = ChatService();

  AdminMessagesPage({super.key}); // Instantiate your chat service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Messages"),
      ),
      body: _buildCustomerList(),
    );
  }

  // Build the list of customers
  Widget _buildCustomerList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getCustomersStream(),
      // Adjust this to fetch customer data
      builder: (context, snapshot) {
        // Handle snapshot states
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading customers"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Display customer list
        // return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user
    if (userData['email'] != const AuthPage().getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData['email'],
                receiverID: userData['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
