import 'dart:ffi';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/components/postdetail.dart';
import 'package:mobile_project/services/post_service.dart';

import '../../models/post_model.dart';
import '../posts_videos/list_post.dart';

class PostTab extends StatefulWidget {
  const PostTab({super.key});

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;
  String? _name;
  String? _id;
  String? _avt;

  PostService _postService = PostService();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    User currentUser = _auth.currentUser!;
    _uid = currentUser.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    _id = userDoc.get('ID');
    _name = userDoc.get('Name');
    _avt = userDoc.get('Avt');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PostModel>>(
      initialData: [], // Initial data can be an empty list
      create: (context) =>
          PostService().getPostsByUser(FirebaseAuth.instance.currentUser?.uid),
      child: Scaffold(
        body: Container(
          child: ListPosts(),
        ),
      ),
    );
  }
}
