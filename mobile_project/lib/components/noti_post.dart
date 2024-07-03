import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/components/video_detail.dart';
import 'package:mobile_project/models/video.dart';
import 'package:mobile_project/models/video_model.dart';
import 'package:mobile_project/screen/posts_videos/post_reply.dart';
import 'package:mobile_project/services/post_service.dart';
import 'package:mobile_project/services/video_service.dart';

class PostNoti extends StatefulWidget {
  final String senderId;
  final String postId;
  final Timestamp timestamp;
  final String action;

  PostNoti({
    required this.senderId,
    required this.postId,
    required this.timestamp,
    required this.action,
  });

  @override
  State<PostNoti> createState() => _PostNotiState();
}

class _PostNotiState extends State<PostNoti> {
  String? _name;
  String? _avt;
  String? _Uname;
  String? _Uavt;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    getUserData();
    getCurrentUserData();
  }

  PostService _postService = PostService();

  void getUserData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.senderId)
        .get();

    setState(() {
      _name = userDoc.get('Name');
      _avt = userDoc.get('Avt');
    });
  }

  void getCurrentUserData() async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    setState(() {
      _Uname = userDoc.get('Name');
      _Uavt = userDoc.get('Avt');
    });
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 365) {
      int months = difference.inDays ~/ 30;
      return '${months}mo';
    } else {
      int years = difference.inDays ~/ 365;
      return '${years}y';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: _avt != null
                  ? NetworkImage(_avt!)
                  : const AssetImage('assets/images/default_avt.png')
                      as ImageProvider,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 6,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$_name ',
                            style: const TextStyle(
                              height: 1,
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "đã ${widget.action} của bạn.",
                            style: const TextStyle(
                              height: 1.4,
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: Text(
                    formatTimestamp(widget.timestamp),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostReply(
                    postId: widget.postId,
                    name: _Uname ?? "",
                    img: _Uavt ?? 'assets/images/default_avt.png',
                    creatorId: userId!,
                  )),
        );
      },
    );
  }
}
