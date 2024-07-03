import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/models/post_model.dart';
import 'package:mobile_project/screen/users/profile_page.dart';
import 'package:mobile_project/services/post_service.dart';

import '../../components/custom_reply.dart';
import 'like_button.dart';

class PostReply extends StatefulWidget {
  PostReply(
      {Key? key,
      required this.postId,
      required this.name,
      required this.img,
      required this.creatorId})
      : super(key: key);
  final String postId;
  final String img;
  final String name;
  final String creatorId;

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
    getCurrentUserData();
    getsumReplyCount();
    isLiked = false;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;

  void getUserData() async {
    User currentUser = _auth.currentUser!;
    _uid = currentUser.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();

    setState(() {
      _avt = userDoc.get('Avt');
      _name = userDoc.get('Name');
    });
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

  void addReplyPost(String content) {
    if (content.trim().isNotEmpty) {
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
      setState(() {
        _showClearButton = false;
      });
      getsumReplyCount();
    }
  }

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
        'likesList': FieldValue.arrayUnion([user.uid])
      });
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<String> ids = [currentUser.uid, "like"];
      String reactorId = ids.join('_');
      if (currentUser.uid != widget.postId) {
        await firestore
            .collection('users')
            .doc(widget.creatorId)
            .collection('notifications')
            .doc(widget.postId)
            .set({
          'postId': widget.postId,
        });

        await firestore
            .collection('users')
            .doc(widget.creatorId)
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
        'likesList': FieldValue.arrayRemove([user.uid])
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
            body: const Center(
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
                        contentPadding:
                            const EdgeInsets.only(left: 15, right: 10),
                        title: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, right: 20),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: widget.img != null
                                    ? NetworkImage(widget.img)
                                    : Image.asset(
                                            'assets/images/default_avt.png')
                                        .image,
                              ),
                            ),
                            Expanded(
                              flex: 5,
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
                              left: 10, top: 15, bottom: 10, right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.content,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  // like button
                                  LikeButton(
                                      isLiked: isLiked, onTap: toggleLike),
                                  Text('  ${likeCount} '),
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
                                  Text('  ${replyCount} '),
                                  const SizedBox(width: 18),
                                  SvgPicture.asset(
                                    'assets/icons/post_repost.svg',
                                    width: 20,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, bottom: 50),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.postId)
                            .collection('replies')
                            .orderBy('timestamp', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
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
                            physics: const NeverScrollableScrollPhysics(),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: _useravt != null
                            ? NetworkImage(_useravt!)
                            : const AssetImage('assets/images/default_avt.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: comment,
                          autofocus: false,
                          maxLines: 5,
                          minLines: 1,
                          cursorColor: Colors.blue,
                          decoration: InputDecoration(
                            hintText: "Thêm bình luận",
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
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
                        onTap: () => addReplyPost(comment.text),
                        child: const Icon(
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
