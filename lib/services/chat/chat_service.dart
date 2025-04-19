import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_app/models/message.dart';
import 'package:final_app/services/auth/auth_page.dart';

class ChatService {
  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current user's role from the chats collection
  Future<String?> getCurrentUserRole() async {
    final user = const AuthPage().getCurrentUser();
    if (user != null) {
      DocumentSnapshot roleSnapshot = await _firestore.collection('chats').doc(user.uid).get();
      if (roleSnapshot.exists) {
        return roleSnapshot.get('role');
      }
    }
    return null; // Return null if user not found or role doesn't exist
  }

  // Get customers stream for admin
  Stream<List<Map<String, dynamic>>> getCustomersStream() {
    return _firestore
        .collection("chats")
        .where('role', isEqualTo: 'customer')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data(); // Return user data with email and uid
      }).toList();
    });
  }

  // Get admins stream for customers
  Stream<List<Map<String, dynamic>>> getAdminsStream() {
    return _firestore
        .collection("chats")
        .where('role', isEqualTo: 'admin')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data(); // Return user data with email and uid
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, message, Timestamp timestamp) async {
    // get current user info
    final String currentUserID = const AuthPage().getCurrentUser()!.uid;
    final String currentUserEmail = const AuthPage().getCurrentUser()!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    // chat room ID for the 2 users
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // add new message to db
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get message
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct a chatroom ID for 2 users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
