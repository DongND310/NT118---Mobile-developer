import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_project/components/custom_follow_notification.dart';
import 'package:mobile_project/components/custom_liked_notification.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Thông báo',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data?.docs ?? [];

          if (notifications.isEmpty) {
            return const Center(child: Text('Không có thông báo'));
          }
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notificationDoc = notifications[index];

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('notifications')
                    .doc(notificationDoc.id)
                    .collection('reactors')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> reactorsSnapshot) {
                  if (!reactorsSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final reactors = reactorsSnapshot.data?.docs ?? [];

                  if (reactors.isEmpty) {
                    return const SizedBox
                        .shrink(); // Trả về một widget trống nếu không có tài liệu
                  }

                  return Column(
                    children: reactors.map((reactor) {
                      return reactor['type'] == 'video_like'
                          ? CustomLikedNotification(
                              senderId: reactor['senderId'],
                              videoId: reactor['videoId'],
                              timestamp: reactor['timestamp'],
                              type: reactor['type'],
                            )
                          : CustomFollowNotification(
                              senderId: reactor['senderId'],
                            );
                    }).toList(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
