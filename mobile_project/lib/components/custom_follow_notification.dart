import 'package:flutter/material.dart';

class CustomFollowNotification extends StatelessWidget {
  final String senderId;

  CustomFollowNotification({
    required this.senderId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(senderId),
      leading: Icon(Icons.person_add, color: Colors.blue),
      onTap: () {
        // Xử lý khi nhấn vào thông báo
      },
    );
  }
}
