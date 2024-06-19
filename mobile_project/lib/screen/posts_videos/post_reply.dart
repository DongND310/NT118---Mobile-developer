import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/models/post_model.dart';
import 'package:mobile_project/screen/posts_videos/list_post.dart';
import 'package:mobile_project/services/post_service.dart';
import 'package:provider/provider.dart';

import '../../components/custom_reply.dart';
import 'like_button.dart';

class PostReply extends StatefulWidget {
  PostReply({Key? key, required this.postId}) : super(key: key);
  final String postId;

  @override
  State<PostReply> createState() => _PostReplyState();
}

class _PostReplyState extends State<PostReply> {
  PostService _postService = PostService();
  final comment = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  String? _avt;
  String? _name;
  bool _showClearButton = false;
  late bool isLiked;
  int likeCount = 0;
  int replyCount = 0;
  @override
  void initState() {
    super.initState();
    getUserData();
    isLiked = false;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          // Đọc danh sách likes từ snapshot và tính độ dài
          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
          List<dynamic> likesList = data?['likesList'];
          likeCount = likesList.length;
          isLiked = likesList.contains(user.uid);

          List<dynamic> repliesList = data?['repliesList'];
          replyCount = repliesList.length;
        });
      }
    });
  }

  void getUserData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    setState(() {
      _avt = userDoc.get('Avt');
      _name = userDoc.get('Name');
    });
  }

  void addReply(String content) {
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc(widget.postId);
    String replyId = FirebaseFirestore.instance.collection('posts').doc().id;

    postRef.update({
      'repliesList': FieldValue.arrayUnion([replyId])
    });

    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('replies')
        .doc(replyId)
        .set({
      "content": content,
      "userId": user.uid,
      "postId": widget.postId,
      "replyId": replyId,
      "timestamp": Timestamp.now()
    });
    comment.clear();
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc(widget.postId);

    Stream<DocumentSnapshot> postStream = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .snapshots();

    if (isLiked) {
      postRef.update({
        'likesList': FieldValue.arrayUnion([user.uid])
      });
    } else {
      postRef.update({
        'likesList': FieldValue.arrayRemove([user.uid])
      });
    }
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
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Bình luận'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final post = PostModel.fromMap(
            snapshot.data!.data() as Map<String, dynamic>, widget.postId);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            shadowColor: Colors.black,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                'assets/icons/ep_back.svg',
                width: 30,
                height: 30,
              ),
            ),
            title: const Text(
              'Bình luận',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 15, right: 10),
                        title: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10, right: 20),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: _avt != null
                                    ? NetworkImage(_avt!)
                                    : Image.asset(
                                            'assets/images/default_avt.png')
                                        .image,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                _name ?? '',
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: Text(
                                    formatTimestamp(post.timestamp),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/post_option.svg',
                                    width: 5,
                                    height: 6,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 15, bottom: 20, right: 5),
                          child: Column(
                            children: [
                              Text(post.content),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  // like button
                                  LikeButton(
                                      isLiked: isLiked, onTap: toggleLike),
                                  const SizedBox(width: 18),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) => PostReply(
                                      //             postId: widget.postId,
                                      //           )),
                                      // );
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icons/post_cmt.svg',
                                      width: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  SvgPicture.asset(
                                    'assets/icons/post_repost.svg',
                                    width: 20,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    '${likeCount} lượt thích',
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    '${replyCount} lượt phản hồi',
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // title: ListPosts(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, bottom: 40),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.postId)
                            .collection('replies')
                            .orderBy('timestamp', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final List<CustomPostReply> replies =
                              snapshot.data!.docs.map((doc) {
                            final replyData =
                                doc.data() as Map<String, dynamic>;
                            return CustomPostReply(
                              content: replyData['content'],
                              userId: replyData['userId'],
                              postId: replyData['postId'],
                              replyId: replyData['replyId'],
                              likesList: [],
                              repliesList: [],
                              timestamp: replyData['timestamp'],
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
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: _avt != null
                            ? NetworkImage(_avt!)
                            : AssetImage('assets/images/default_avt.png')
                                as ImageProvider,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: comment,
                          autofocus: false,
                          maxLines: 1,
                          cursorColor: Colors.blue,
                          decoration: InputDecoration(
                            hintText: "Thêm bình luận",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            suffixIcon: _showClearButton
                                ? IconButton(
                                    icon: Icon(
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
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => addReply(comment.text),
                        child: Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
