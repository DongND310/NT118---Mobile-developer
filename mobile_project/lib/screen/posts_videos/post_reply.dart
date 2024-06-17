import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/models/post_model.dart';
import 'package:mobile_project/models/user.dart';
import 'package:mobile_project/screen/posts_videos/list_post.dart';
import 'package:mobile_project/services/post_service.dart';
import 'package:provider/provider.dart';

import '../../components/custom_reply.dart';

class PostReply extends StatefulWidget {
  PostReply({super.key, required this.postId});
  final String postId;
  @override
  State<PostReply> createState() => _PostReplyState();
}

class _PostReplyState extends State<PostReply> {
  PostService _postService = PostService();
  final comment = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _showClearButton = false;
  String? _uid;
  String? _avt;
  int likeCount = 0;
  int replyCount = 0;
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    _uid = user.uid;

    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();

    setState(() {
      _avt = userDoc.get('Avt');
    });
  }

  void addReply(String content) {
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc(widget.postId);

    postRef.update({
      'repliesList': FieldValue.arrayUnion([user.uid])
    });

    String replyId = FirebaseFirestore.instance.collection('posts').doc().id;

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

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PostModel>>(
        create: (_) => _postService.getPostsById(widget.postId),
        initialData: [],
        child: Container(
            child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            shadowColor: Colors.black,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0.5,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => NavigationContainer(
                //             currentUserID: _uid!,
                //             pageIndex: 4,
                //           )
                //       ),
                // );
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
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: Container(
            child: Stack(
              children: [
                // get post
                ListPosts(),
                // Expanded(child: ListPosts()),
                // get comment
                SizedBox(
                  height: 30,
                ),
                StreamBuilder<QuerySnapshot>(
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

                    return Padding(
                      padding: const EdgeInsets.only(left: 30, bottom: 50),
                      child: ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.docs.map((doc) {
                          final replyData = doc.data() as Map<String, dynamic>;

                          return CustomPostReply(
                            content: replyData['content'],
                            userId: replyData['userId'],
                            postId: replyData['postId'],
                            replyId: replyData['replyId'],
                            likesList: [],
                            repliesList: [],
                            timestamp: replyData['timestamp'],
                          );
                        }).toList(),
                      ),
                    );
                  },
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
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: _avt != null
                                ? NetworkImage(_avt!)
                                : Image.asset('assets/images/default_avt.png')
                                    .image,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 270,
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 30),
                                child: TextField(
                                  controller: comment,
                                  autofocus: false,
                                  maxLines: 10,
                                  minLines: 1,
                                  cursorColor: Colors.blue,
                                  decoration: const InputDecoration(
                                    hintText: "Thêm bình luận",
                                    hintStyle: TextStyle(
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
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: IconButton(
                                    icon: Icon(
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
                        SizedBox(width: 20),
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
                )
              ],
            ),
          ),
        )));
  }
}
