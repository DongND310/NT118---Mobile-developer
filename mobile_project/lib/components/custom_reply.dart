import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/components/custom_delete.dart';
import 'package:mobile_project/components/custom_subreply.dart';
import 'package:mobile_project/components/delete_cmt.dart';
import 'package:mobile_project/screen/users/profile_page.dart';

import '../screen/posts_videos/like_button.dart';

class CustomPostReply extends StatefulWidget {
  final String content;
  final String postId;
  final String userId;
  final String replyId;
  final List<String> likesList;
  final List<String> repliesList;
  final Timestamp timestamp;
  CustomPostReply(
      {super.key,
      required this.content,
      required this.postId,
      required this.userId,
      required this.replyId,
      required this.likesList,
      required this.repliesList,
      required this.timestamp});

  @override
  State<CustomPostReply> createState() => _CustomPostReplyState();
}

class _CustomPostReplyState extends State<CustomPostReply> {
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
  late bool isSubLiked;
  late bool isSubRepLiked;
  int likeCount = 0;
  int replyCount = 0;
  String? _name;
  String? _avt;
  TextEditingController _replyController = TextEditingController();
  bool _showReplyField = false;
  TextEditingController comment = TextEditingController();
  bool _showClearButton = false;
  bool isSubReply = false;

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
    getUserData();
    listenToReplyChanges();

    isLiked = false;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('replies')
        .doc(widget.replyId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
          List<dynamic> likesList = data?['likesList'];
          likeCount = likesList.length;
          isLiked = likesList.contains(currentUser.uid);

          List<dynamic> repliesList = data?['repliesList'];
          // replyCount = repliesList.length;
        });
      }
    });
  }

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

    DocumentReference postRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('replies')
        .doc(widget.replyId);

    if (isLiked) {
      postRef.update({
        'likesList': FieldValue.arrayUnion([currentUser.uid])
      });
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<String> ids = [currentUser.uid, "likecmt", widget.replyId];
      String reactorId = ids.join('_');
      if (currentUser.uid != widget.postId) {
        await firestore
            .collection('users')
            .doc(widget.userId)
            .collection('notifications')
            .doc(widget.postId)
            .set({
          'postId': widget.postId,
        });

        await firestore
            .collection('users')
            .doc(widget.userId)
            .collection('notifications')
            .doc(widget.postId)
            .collection('reactors')
            .doc(reactorId)
            .set({
          'type': 'post_cmt_like',
          'senderId': currentUser.uid,
          'postId': widget.postId,
          'replyId': widget.replyId,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } else {
      postRef.update({
        'likesList': FieldValue.arrayRemove([currentUser.uid])
      });
    }
  }

  void showReplyField() {
    setState(() {
      _showReplyField = true;
      comment.text = '@${_name ?? ''}: ';
    });
  }

  void addReplyComment(String content) async {
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('replies')
        .doc(widget.replyId);

    // Add subreply
    String subreplyId = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('replies')
        .doc(widget.replyId)
        .collection('subreplies')
        .doc()
        .id;
    postRef.update({
      'repliesList': FieldValue.arrayUnion([subreplyId])
    });

    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('replies')
        .doc(widget.replyId)
        .collection('subreplies')
        .doc(subreplyId)
        .set({
      "content": content,
      "userId": currentUser.uid,
      "postId": widget.postId,
      "replyId": widget.replyId,
      "subreplyId": subreplyId,
      "timestamp": Timestamp.now()
    });

    comment.clear();
    setState(() {
      _showReplyField = false;
    });

    // noti
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<String> ids = [currentUser.uid, "replycmt", subreplyId];
    String reactorId = ids.join('_');
    if (currentUser.uid != widget.userId) {
      await firestore
          .collection('users')
          .doc(widget.userId)
          .collection('notifications')
          .doc(widget.postId)
          .set({
        'postId': widget.postId,
      });

      await firestore
          .collection('users')
          .doc(widget.userId)
          .collection('notifications')
          .doc(widget.postId)
          .collection('reactors')
          .doc(reactorId)
          .set({
        'type': 'post_cmt_reply',
        'senderId': currentUser.uid,
        'postId': widget.postId,
        'replyId': subreplyId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  void listenToReplyChanges() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('replies')
        .doc(widget.replyId)
        .collection('subreplies')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        replyCount = snapshot.docs.length;
      });
    });
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
              // avt
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: _avt != null
                      ? NetworkImage(_avt!)
                      : Image.asset('assets/images/default_avt.png').image,
                ),
              ),

              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // account name
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ),

                          // time
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  formatTimestamp(widget.timestamp),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (widget.userId == user.uid) {
                                      showBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) {
                                            return DraggableScrollableSheet(
                                              maxChildSize: 0.15,
                                              initialChildSize: 0.15,
                                              minChildSize: 0.1,
                                              builder:
                                                  (context, scrollController) {
                                                return DeleteComment(
                                                  id: widget.postId,
                                                  cmtId: widget.replyId,
                                                  userId: user.uid,
                                                );
                                              },
                                            );
                                          });
                                    }
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/post_option.svg',
                                    width: 6,
                                    height: 6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),

                    const SizedBox(height: 10),
                    // post content
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        widget.content,
                        style: const TextStyle(color: Colors.black),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // like button
                            LikeButton(isLiked: isLiked, onTap: toggleLike),
                            Text('  ${likeCount} '),
                            const SizedBox(width: 18),
                            GestureDetector(
                              onTap: showReplyField,
                              child: SvgPicture.asset(
                                'assets/icons/post_cmt.svg',
                                width: 20,
                                color: Colors.blue,
                              ),
                            ),
                            Text('  ${replyCount} '),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, bottom: 10),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postId)
                .collection('replies')
                .doc(widget.replyId)
                .collection('subreplies')
                .orderBy('timestamp', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                );
              }

              final List<CustomSubReply> subreplies =
                  snapshot.data!.docs.map((doc) {
                final subreplyData = doc.data() as Map<String, dynamic>;
                return CustomSubReply(
                  content: subreplyData['content'],
                  userId: subreplyData['userId'],
                  postId: subreplyData['postId'],
                  replyId: subreplyData['replyId'],
                  subreplyId: subreplyData['subreplyId'],
                  likesList: [],
                  repliesList: [],
                  timestamp: subreplyData['timestamp'],
                );
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
        if (_showReplyField)
          Container(
            margin: const EdgeInsets.only(bottom: 30, left: 30, right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: _useravt != null
                      ? NetworkImage(_useravt!)
                      : const AssetImage('assets/images/default_avt.png')
                          as ImageProvider,
                ),
                Expanded(
                  child: TextField(
                    controller: comment,
                    autofocus: true,
                    maxLines: 10,
                    minLines: 1,
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      hintText: "Thêm bình luận",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      suffixIcon: _showClearButton
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                comment.clear();
                                setState(() {
                                  _showClearButton = false;
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _showClearButton = value.isNotEmpty;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => addReplyComment(comment.text),
                  child: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
