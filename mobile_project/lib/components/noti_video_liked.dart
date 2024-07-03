import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/components/video_detail.dart';
import 'package:mobile_project/models/video.dart';
import 'package:mobile_project/models/video_model.dart';
import 'package:mobile_project/services/video_service.dart';

class LikeVideoNoti extends StatefulWidget {
  final String senderId;
  final String videoId;
  final Timestamp timestamp;

  LikeVideoNoti({
    required this.senderId,
    required this.videoId,
    required this.timestamp,
  });

  @override
  State<LikeVideoNoti> createState() => _LikeVideoNotiState();
}

class _LikeVideoNotiState extends State<LikeVideoNoti> {
  String? _name;
  String? _avt;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  VideoService _service = VideoService();

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
              width: 20,
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
                          const TextSpan(
                            text: " đã thích video của bạn.",
                            style: TextStyle(
                              height: 1.2,
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
        List<VideoModel> videos = await fetchVideos();
        VideoModel? video = videos.firstWhere(
          (video) => video.videoId == widget.videoId,
          orElse: null,
        );
        if (video != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoDetailScreen(video: video),
            ),
          );
        } else {
          print('Không tìm thấy video với id: ${widget.videoId}');
        }
      },
    );
  }
}
