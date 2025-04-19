import 'package:final_app/services/auth/auth_page.dart';
import 'package:final_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import '../../components/user_tile.dart';
import '../chat_page.dart';

class CustomerMessagesPage extends StatelessWidget {
  CustomerMessagesPage({super.key});

  // chat service
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        title: Text("Messages", style: TextStyle(fontFamily: "Mont",color: Theme.of(context).colorScheme.primary),),
        automaticallyImplyLeading: false,
      ),
      body: _buildUserList(),
    );
  }

// build a list of users other than current logged in
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getAdminsStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

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
