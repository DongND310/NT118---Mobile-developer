import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/components/custom_comment.dart';
import 'package:mobile_project/models/video_model.dart';

class CommentPage extends StatefulWidget {
  CommentPage({super.key, required this.video});
  final VideoModel video;

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController comment = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? replyUserId; // Lưu userId của người dùng cần trả lời
  String? replyUserName; // Lưu tên của người dùng cần trả lời
  bool _showClearButton = false;
  String? _uid;
  String? _avt;
  int replyCount = 0;

  @override
  void initState() {
    super.initState();
    getUserData();
    getCurrentUserData();
    getsumReplyCount();
  }

  void getUserData() async {
    User currentUser = _auth.currentUser!;
    _uid = currentUser.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    _avt = userDoc.get('avt');
    setState(() {});
  }

  final currentUser = FirebaseAuth.instance.currentUser!;
  String? _useravt;

  void getCurrentUserData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    setState(() {
      _useravt = userDoc.get('Avt');
    });
  }

  String replyId = FirebaseFirestore.instance.collection('videos').doc().id;
  void addCommentVideo(String content) {
    if (content.trim().isNotEmpty) {
      DocumentReference videoRef = FirebaseFirestore.instance
          .collection('videos')
          .doc(widget.video.videoId);
      videoRef.update({
        'repliesList': FieldValue.arrayUnion([replyId])
      });

      FirebaseFirestore.instance
          .collection('videos')
          .doc(widget.video.videoId)
          .collection('replies')
          .doc(replyId)
          .set({
        "content": content,
        "userId": user.uid,
        "videoId": widget.video.videoId,
        "replyId": replyId,
        "timestamp": Timestamp.now()
      });
      comment.clear();
      setState(() {
        _showClearButton = false;
      });
      getsumReplyCount();
    }
    print("content cmt: $content");
  }

  void addReplyComment(String content) {
    DocumentReference videoRef = FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId)
        .collection('replies')
        .doc(widget.video.videoId);

    // Add subreply
    String subreplyId = FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId)
        .collection('replies')
        .doc(widget.video.videoId)
        .collection('subreplies')
        .doc()
        .id;
    videoRef.update({
      'repliesList': FieldValue.arrayUnion([subreplyId])
    });

    FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId)
        .collection('replies')
        .doc(replyId)
        .collection('subreplies')
        .doc(subreplyId)
        .set({
      "content": content,
      "userId": replyUserId,
      "videoId": widget.video.videoId,
      "replyId": replyId,
      "subreplyId": subreplyId,
      "timestamp": Timestamp.now()
    });

    comment.clear();
    setState(() {
      // _showReplyField = false;
    });
  }

  void getsumReplyCount() async {
    int totalReplies = 0;

    QuerySnapshot repliesSnapshot = await FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId)
        .collection('replies')
        .get();
    totalReplies += repliesSnapshot.docs.length;

    for (QueryDocumentSnapshot replyDoc in repliesSnapshot.docs) {
      QuerySnapshot subrepliesSnapshot = await FirebaseFirestore.instance
          .collection('videos')
          .doc(widget.video.videoId)
          .collection('replies')
          .doc(replyDoc.id)
          .collection('subreplies')
          .get();
      totalReplies += subrepliesSnapshot.docs.length;
    }

    setState(() {
      replyCount = totalReplies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: Container(
        color: Colors.white,
        height: 300,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(width: 90, height: 2, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, bottom: 50, left: 15, right: 20),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('videos')
                    .doc(widget.video.videoId)
                    .collection('replies')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final List<CustomComment> replies =
                      snapshot.data!.docs.map((doc) {
                    final replyData = doc.data() as Map<String, dynamic>;
                    return CustomComment(
                      content: replyData['content'],
                      userId: replyData['userId'],
                      videoId: replyData['videoId'],
                      replyId: replyData['replyId'],
                      likesList: [],
                      repliesList: [],
                      timestamp: replyData['timestamp'],
                      replyCallback: (String userId, String userName) {
                        replyToUser(userId, userName);
                      },
                    );
                  }).toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: replies.length,
                    itemBuilder: (context, index) {
                      return replies[index];
                    },
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: _useravt != null
                            ? NetworkImage(_useravt!)
                            : Image.asset('assets/images/default_avt.png')
                                .image,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        width: 270,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 50),
                              child: TextField(
                                controller: comment,
                                autofocus: false,
                                maxLines: 8,
                                minLines: 1,
                                cursorColor: Colors.blue,
                                decoration: InputDecoration(
                                  hintText: replyUserName != null
                                      ? "Trả lời @$replyUserName"
                                      : "Thêm bình luận",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _showClearButton = value.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            if (_showClearButton)
                              Positioned(
                                right: 10,
                                top: 0,
                                bottom: 0,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    comment.clear();
                                    setState(() {
                                      _showClearButton = false;
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => replyUserName != null
                            ? addReplyComment(comment.text)
                            : addCommentVideo(comment.text),
                        child: const Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void replyToUser(String userId, String userName) {
    setState(() {
      replyUserId = userId;
      replyUserName = userName;
    });
  }
}
