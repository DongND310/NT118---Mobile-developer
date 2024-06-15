import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/models/post_model.dart';
import 'package:mobile_project/services/post_service.dart';
import 'package:mobile_project/services/user_service.dart';
import 'package:provider/provider.dart';

import '../../components/postdetail.dart';
import '../../models/user_model.dart';

class ListPosts extends StatefulWidget {
  const ListPosts({super.key});

  @override
  State<ListPosts> createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;
  String? _name;
  String? _id;
  String? _avt;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _uid = currentUser.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      setState(() {
        _id = userDoc.get('ID');
        _name = userDoc.get('Name');
        _avt = userDoc.get('Avt');
      });
    }
  }

  UserService _userService = UserService();
  PostService _postService = PostService();

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
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return StreamBuilder(
                  stream: _postService.getCurrentUserLike(post),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshotLike) {
                    if (!snapshotLike.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PostDetailScreen(
                            name: _name ?? '',
                            content: post.content,
                            img: _avt ?? '',
                            like: post.like!,
                            reply: post.reply!,
                            time: post.timestamp,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 65),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      child: SvgPicture.asset(
                                        snapshotLike.data!
                                            ? 'assets/icons/post_liked.svg'
                                            : 'assets/icons/post_like.svg',
                                        width: 20,
                                        // color: Colors.blue,
                                      ),
                                      onTap: () {
                                        _postService.likePost(
                                            post, snapshotLike.data!);
                                      },
                                    ),
                                    const SizedBox(width: 18),
                                    SvgPicture.asset(
                                      'assets/icons/post_cmt.svg',
                                      width: 20,
                                      color: Colors.blue,
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
                                      '${post.like} lượt thích',
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 14),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      '${post.reply} lượt phản hồi',
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Divider(),
                              ],
                            ),
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
