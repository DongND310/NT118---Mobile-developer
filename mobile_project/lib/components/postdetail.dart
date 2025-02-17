import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/components/custom_delete.dart';
import 'package:mobile_project/screen/posts_videos/like_button.dart';
import 'package:mobile_project/screen/users/profile_page.dart';

import '../screen/posts_videos/post_reply.dart';

class PostDetailScreen extends StatefulWidget {
  final String name;
  final String content;
  final String img;
  final String postId;
  final List<String> likesList;
  final List<String> repliesList;
  final Timestamp time;
  final String id;
  final String creatorId;

  PostDetailScreen({
    super.key,
    required this.name,
    required this.content,
    required this.img,
    required this.postId,
    required this.likesList,
    required this.repliesList,
    required this.time,
    required this.id,
    required this.creatorId,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
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
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();

    getsumReplyCount();
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
          isLiked = likesList.contains(currentUser.uid);

          List<dynamic> repliesList = data?['repliesList'];
          replyCount = repliesList.length;
        });
      }
    });
  }

  final currentUser = FirebaseAuth.instance.currentUser!;

  void toggleLike() async {
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
        'likesList': FieldValue.arrayUnion([currentUser.uid])
      });
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<String> ids = [currentUser.uid, "like"];
      String reactorId = ids.join('_');
      if (currentUser.uid != widget.postId) {
        await firestore
            .collection('users')
            .doc(widget.id)
            .collection('notifications')
            .doc(widget.postId)
            .set({
          'postId': widget.postId,
        });

        await firestore
            .collection('users')
            .doc(widget.id)
            .collection('notifications')
            .doc(widget.postId)
            .collection('reactors')
            .doc(reactorId)
            .set({
          'type': 'post_like',
          'senderId': currentUser.uid,
          'postId': widget.postId,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } else {
      postRef.update({
        'likesList': FieldValue.arrayRemove([currentUser.uid])
      });
    }
  }

  void getsumReplyCount() async {
    int totalReplies = 0;

    QuerySnapshot repliesSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('replies')
        .get();
    totalReplies += repliesSnapshot.docs.length;

    for (QueryDocumentSnapshot replyDoc in repliesSnapshot.docs) {
      QuerySnapshot subrepliesSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
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
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // avt
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: widget.img != null
                  ? NetworkImage(widget.img!)
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
                                    visitedUserID: widget.creatorId,
                                    currentUserId: currentUser.uid,
                                    isBack: true,
                                  ),
                                ));
                          },
                          child: Text(
                            widget.name ?? '',
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),

                      // time, option
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: Text(
                                formatTimestamp(widget.time),
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
                                if (widget.creatorId == user.uid) {
                                  showBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (context) {
                                        return DraggableScrollableSheet(
                                          maxChildSize: 0.15,
                                          initialChildSize: 0.15,
                                          minChildSize: 0.1,
                                          builder: (context, scrollController) {
                                            return DeleteScreen(
                                              id: widget.postId,
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostReply(
                                        postId: widget.postId,
                                        name: widget.name!,
                                        img: widget.img!,
                                        creatorId: widget.creatorId,
                                      )),
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/icons/post_cmt.svg',
                            width: 20,
                            color: Colors.blue,
                          ),
                        ),

                        Text('  ${replyCount} '),
                        const SizedBox(width: 18),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
