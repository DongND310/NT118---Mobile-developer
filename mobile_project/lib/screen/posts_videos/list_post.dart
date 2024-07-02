import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/models/post_model.dart';
import 'package:mobile_project/services/post_service.dart';
import 'package:mobile_project/services/user_service.dart';
import 'package:provider/provider.dart';

import '../../components/postdetail.dart';
import '../../models/user_model.dart';

class ListPosts extends StatefulWidget {
  ListPosts({super.key, required this.visitedUserID});
  final String visitedUserID;
  @override
  State<ListPosts> createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;
  String? _name;
  String? _avt;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    if (widget.visitedUserID != null) {
      // _uid = currentUser.uid;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.visitedUserID)
          .get();
      setState(() {
        _name = userDoc.get('Name');
        _avt = userDoc.get('Avt');
      });
    }

    print("tên trang cá nhân: $_name");
  }

  final UserService _userService = UserService();
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<PostModel>?>(context) ?? [];
    posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return StreamBuilder(
            stream: _userService.getUserInfo(post.creatorId),
            builder:
                (BuildContext context, AsyncSnapshot<UserModel> snapshotUser) {
              if (!snapshotUser.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return StreamBuilder(
                  stream: _postService.getCurrentUserLike(post),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshotLike) {
                    DocumentReference postRef = FirebaseFirestore.instance
                        .collection('posts')
                        .doc(post.postId);

                    if (!snapshotLike.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PostDetailScreen(
                            // name: _name ?? '',
                            name: _name ?? '',
                            content: post.content,
                            img: _avt ?? '',
                            postId: post.postId,
                            likesList: [],
                            repliesList: [],
                            time: post.timestamp,
                            id: widget.visitedUserID,
                          ),
                        ],
                      ),
                    );
                  });
            });
      },
    );
  }
}
