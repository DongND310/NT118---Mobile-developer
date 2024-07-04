import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/screen/users/profile_page.dart';

class CustomCommentReply extends StatefulWidget {
  final String content;
  final String userId;
  final String videoId;
  final String replyId;
  final String subreplyId;
  final List<String> likesList;
  final List<String> repliesList;
  final Timestamp timestamp;
  final Function(String, String, String) replyCallback;
  final Function(String, String, String, String) subreplyCallback;

  CustomCommentReply({
    super.key,
    required this.content,
    required this.userId,
    required this.videoId,
    required this.replyId,
    required this.subreplyId,
    required this.likesList,
    required this.repliesList,
    required this.timestamp,
    required this.replyCallback,
    required this.subreplyCallback,
  });

  @override
  State<CustomCommentReply> createState() => _CustomCommentReplyState();
}

class _CustomCommentReplyState extends State<CustomCommentReply> {
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

  late bool isLiked;
  int likeCount = 0;
  int replyCount = 0;
  String? _name;
  String? _avt;
  TextEditingController _replyController = TextEditingController();
  TextEditingController comment = TextEditingController();
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    getUserData();

    isLiked = false;
    FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.videoId)
        .collection('replies')
        .doc(widget.replyId)
        .collection('subreplies')
        .doc(widget.subreplyId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
          List<dynamic> likesList = data?['likesList'];
          likeCount = likesList.length;
          isLiked = likesList.contains(currentUser.uid);

          List<dynamic> repliesList = data?['repliesList'];
          replyCount = repliesList.length;
        });
      }
    });
  }

  void getUserData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    setState(() {
      _name = userDoc.get('Name');
      _avt = userDoc.get('Avt');
    });
  }

  final currentUser = FirebaseAuth.instance.currentUser!;

  void toggleLike() async {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference videoRef = FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.videoId)
        .collection('replies')
        .doc(widget.replyId)
        .collection('subreplies')
        .doc(widget.subreplyId);

    if (isLiked) {
      videoRef.update({
        'likesList': FieldValue.arrayUnion([currentUser.uid])
      });
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<String> ids = [currentUser.uid, "likereply", widget.subreplyId];
      String reactorId = ids.join('_');
      if (currentUser.uid != widget.userId) {
        await firestore
            .collection('users')
            .doc(widget.userId)
            .collection('notifications')
            .doc(widget.videoId)
            .set({
          'videoId': widget.videoId,
        });

        await firestore
            .collection('users')
            .doc(widget.userId)
            .collection('notifications')
            .doc(widget.videoId)
            .collection('reactors')
            .doc(reactorId)
            .set({
          'type': 'video_cmt_like',
          'senderId': currentUser.uid,
          'videoId': widget.videoId,
          'replyId': widget.subreplyId,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } else {
      videoRef.update({
        'likesList': FieldValue.arrayRemove([currentUser.uid])
      });
    }
  }

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: _avt != null
                    ? NetworkImage(_avt!)
                    : Image.asset('assets/images/default_avt.png').image,
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // account name
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                visitedUserID: widget.userId,
                                currentUserId: currentUser.uid,
                                isBack: true,
                              ),
                            ));
                      },
                      child: Text(
                        _name ?? '',
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 320,
                      child: Text(
                        widget.content,
                        style: const TextStyle(color: Colors.black),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                formatTimestamp(widget.timestamp),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  widget.replyCallback(widget.userId,
                                      _name ?? '', widget.subreplyId);
                                },
                                child: const Text("Trả lời",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              _likeComment(() => toggleLike(), isLiked),
                              Text(
                                "   ${likeCount}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('videos')
                .doc(widget.videoId)
                .collection('replies')
                .doc(widget.replyId)
                .collection('subreplies')
                .doc(widget.subreplyId)
                .collection('subreplies')
                .orderBy('timestamp', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                );
              }

              final List<CustomCommentReply> subreplies =
                  snapshot.data!.docs.map((doc) {
                final subreplyData = doc.data() as Map<String, dynamic>;
                return CustomCommentReply(
                    videoId: subreplyData['videoId'],
                    content: subreplyData['content'],
                    userId: subreplyData['userId'],
                    subreplyId: subreplyData['subreplyId'],
                    replyId: subreplyData['replyId'],
                    likesList: [],
                    repliesList: [],
                    timestamp: subreplyData['timestamp'],
                    replyCallback: widget.replyCallback,
                    subreplyCallback: widget.subreplyCallback);
              }).toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subreplies.length,
                itemBuilder: (context, index) {
                  return subreplies[index];
                },
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  _likeComment(Function() onTap, bool isLike) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        isLiked ? 'assets/icons/post_liked.svg' : 'assets/icons/post_like.svg',
        width: 20,
      ),
    );
  }
}
