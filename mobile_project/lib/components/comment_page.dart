import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/components/custom_comment.dart';
import 'package:mobile_project/models/video_model.dart';

class CommentPage extends StatefulWidget {
  CommentPage({Key? key, required this.video}) : super(key: key);
  final VideoModel video;

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController comment = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? replyUserId;
  String? replyUserName;
  bool _showClearButton = false;

  String? currentReplyId;
  String? currentSubReplyId;
  String? _uid;
  String? _useravt;
  int replyCount = 0;

  @override
  void initState() {
    super.initState();
    getUserData();
    getCurrentUserData();
    getTotalReplyCount();
  }

  void getUserData() async {
    User currentUser = _auth.currentUser!;
    _uid = currentUser.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    setState(() {
      _useravt = userDoc.get('avt');
    });
  }

  void getCurrentUserData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    setState(() {
      _useravt = userDoc.get('Avt');
    });
  }

  void addCommentVideo(String content) async {
    if (content.trim().isNotEmpty) {
      String replyId = FirebaseFirestore.instance.collection('videos').doc().id;

      DocumentReference videoRef = FirebaseFirestore.instance
          .collection('videos')
          .doc(widget.video.videoId);
      await videoRef.update({
        'repliesList': FieldValue.arrayUnion([replyId])
      });

      await FirebaseFirestore.instance
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
        replyUserId = null;
        replyUserName = null;
        currentReplyId = null;
      });
      getTotalReplyCount();
    }
  }

  void addReplyComment(String content, String replyId) async {
    String subreplyId = FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId)
        .collection('replies')
        .doc()
        .id;

    DocumentReference videoRef = FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId)
        .collection('replies')
        .doc(replyId);

    // await videoRef.update({
    //   'repliesList': FieldValue.arrayUnion([subreplyId])
    // });

    await FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId)
        .collection('replies')
        .doc(replyId)
        .collection('subreplies')
        .doc(subreplyId)
        .set({
      "content": content,
      "userId": user.uid,
      "videoId": widget.video.videoId,
      "replyId": replyId,
      "subreplyId": subreplyId,
      "timestamp": Timestamp.now()
    });

    comment.clear();
    setState(() {
      _showClearButton = false;
      replyUserId = null;
      replyUserName = null;
      currentReplyId = null;
    });
  }

  void addSubReplyComment(
      String content, String replyId, String subreplyId) async {
    String subsubreplyId = FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId)
        .collection('replies')
        .doc(replyId)
        .collection('subreplies')
        .doc()
        .id;

    DocumentReference videoRef = FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId)
        .collection('replies')
        .doc(replyId)
        .collection('subreplies')
        .doc(subreplyId);

    await videoRef.update({
      'repliesList': FieldValue.arrayUnion([subsubreplyId])
    });

    await FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId)
        .collection('replies')
        .doc(replyId)
        .collection('subreplies')
        .doc(subsubreplyId)
        .set({
      "content": content,
      "userId": user.uid,
      "videoId": widget.video.videoId,
      "replyId": replyId,
      "subreplyId": subsubreplyId,
      "timestamp": Timestamp.now()
    });

    comment.clear();
    setState(() {
      _showClearButton = false;
      replyUserId = null;
      replyUserName = null;
      currentReplyId = null;
    });
  }

  void getTotalReplyCount() async {
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
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child:
                          Container(width: 90, height: 2, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30, bottom: 80, left: 15, right: 20),
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
                            replyCallback: (userId, userName, replyId) {
                              replyToUser(userId, userName, replyId);
                            },
                            subreplyCallback:
                                (userId, userName, replyId, subreplyId) {
                              replyToSubUser(
                                  userId, userName, replyId, subreplyId);
                            },
                          );
                        }).toList();

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: replies.length,
                          itemBuilder: (context, index) {
                            return replies[index];
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 100,
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
                                      replyUserId = null;
                                      replyUserName = null;
                                      currentReplyId = null;
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
                        onTap: () {
                          if (replyUserName != null) {
                            if (currentSubReplyId != null) {
                              addSubReplyComment(
                                  comment.text,
                                  currentReplyId ?? "",
                                  currentSubReplyId ?? "");
                            } else {
                              addReplyComment(
                                  comment.text, currentReplyId ?? "");
                            }
                          } else {
                            addCommentVideo(comment.text);
                          }
                        },
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

  void replyToUser(String userId, String userName, String replyId) {
    setState(() {
      replyUserId = userId;
      replyUserName = userName;
      currentReplyId = replyId;
      comment.text = "@$userName: ";
      comment.selection =
          TextSelection.fromPosition(TextPosition(offset: comment.text.length));
    });
  }

  void replyToSubUser(
      String userId, String userName, String replyId, String subreplyId) {
    setState(() {
      replyUserId = userId;
      replyUserName = userName;
      currentReplyId = replyId;
      currentSubReplyId = subreplyId;
    });
  }
}
