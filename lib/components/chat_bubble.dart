import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.green : Colors.blue[900],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 2.5),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "Mont",
              fontSize: 16,
            ),
          ),
        ),
        // Display the timestamp
        Padding(
          padding: const EdgeInsets.only(right: 25, left: 25),
          child: Text(
            timestamp,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontFamily: "Mont"
            ),
          ),
        ),
      ],
    );
  }
}
