import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mobile_project/components/custom_follow_notification.dart';
import 'package:mobile_project/components/noti_post.dart';
import 'package:mobile_project/components/noti_video.dart';

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

          // Tạo danh sách các stream của reactors
          List<Stream<QuerySnapshot>> reactorStreams =
              notifications.map((notification) {
            return FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('notifications')
                .doc(notification.id)
                .collection('reactors')
                .snapshots();
          }).toList();

          // Sử dụng rxdart để hợp nhất các stream thành một stream duy nhất
          return StreamBuilder(
            stream: Rx.combineLatestList(reactorStreams),
            builder:
                (context, AsyncSnapshot<List<QuerySnapshot>> combinedSnapshot) {
              if (!combinedSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              // Tạo danh sách tổng hợp các reactors
              List<DocumentSnapshot> combinedReactors = [];
              for (var snapshot in combinedSnapshot.data!) {
                combinedReactors.addAll(snapshot.docs);
              }

              // Sắp xếp các reactors theo timestamp
              combinedReactors
                  .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

              return ListView.builder(
                itemCount: combinedReactors.length,
                itemBuilder: (context, index) {
                  final reactor = combinedReactors[index];

                  return reactor['type'] == 'video_like'
                      ? VideoNoti(
                          senderId: reactor['senderId'],
                          videoId: reactor['videoId'],
                          timestamp: reactor['timestamp'],
                          action: "thích video")
                      : reactor['type'] == 'video_save'
                          ? VideoNoti(
                              senderId: reactor['senderId'],
                              videoId: reactor['videoId'],
                              timestamp: reactor['timestamp'],
                              action: "lưu video")
                          : reactor['type'] == 'video_cmt'
                              ? VideoNoti(
                                  senderId: reactor['senderId'],
                                  videoId: reactor['videoId'],
                                  timestamp: reactor['timestamp'],
                                  action: "bình luận về video")
                              : reactor['type'] == 'video_cmt_like'
                                  ? VideoNoti(
                                      senderId: reactor['senderId'],
                                      videoId: reactor['videoId'],
                                      timestamp: reactor['timestamp'],
                                      action: "thích bình luận")
                                  : reactor['type'] == 'video_cmt_reply'
                                      ? VideoNoti(
                                          senderId: reactor['senderId'],
                                          videoId: reactor['videoId'],
                                          timestamp: reactor['timestamp'],
                                          action: "phản hồi về bình luận")
                                      : reactor['type'] == 'post_like'
                                          ? PostNoti(
                                              senderId: reactor['senderId'],
                                              postId: reactor['postId'],
                                              timestamp: reactor['timestamp'],
                                              action: "thích bài đăng")
                                          : reactor['type'] == 'post_cmt'
                                              ? PostNoti(
                                                  senderId: reactor['senderId'],
                                                  postId: reactor['postId'],
                                                  timestamp:
                                                      reactor['timestamp'],
                                                  action:
                                                      "bình luận về bài đăng")
                                              : CustomFollowNotification(
                                                  senderId: reactor['senderId'],
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
