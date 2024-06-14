import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/models/post_model.dart';
import 'package:provider/provider.dart';

import '../../components/post.dart';

class ListPosts extends StatefulWidget {
  const ListPosts({super.key});

  @override
  State<ListPosts> createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<PostModel>>(context) ?? [];
    posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: PostDetailScreen(
            name: post.creatorName,
            content: post.content,
            img: post.creatorImg,
            like: 0,
            reply: 0,
            time: post.timestamp,
          ),
        );
      },
    );
  }
}
