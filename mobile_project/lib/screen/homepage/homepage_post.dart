import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/components/postdetail.dart';

class HPPostTab extends StatefulWidget {
  const HPPostTab({super.key, required this.currentId});
  final String currentId;

  @override
  State<HPPostTab> createState() => _HPPostTabState();
}

class _HPPostTabState extends State<HPPostTab> {
  Future<Map<String, dynamic>> getUserDataById(String id) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    return {
      'avt': userDoc.get('Avt'),
      'name': userDoc.get('Name'),
    };
  }

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
          );
        }

        var posts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            var post = posts[index];
            var postData = post.data() as Map<String, dynamic>;

            return FutureBuilder<Map<String, dynamic>>(
              future: getUserDataById(postData['creatorId']),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    ),
                  );
                }

                var userData = userSnapshot.data!;
                var name = userData['name'];
                var avt = userData['avt'];

                // Ensure the lists are of type List<String> and not null
                List<String> likesList = postData.containsKey('likesList')
                    ? List<String>.from(postData['likesList'])
                    : [];
                List<String> repliesList = postData.containsKey('repliesList')
                    ? List<String>.from(postData['repliesList'])
                    : [];

                return PostDetailScreen(
                  name: name,
                  content: postData['content'] ?? '',
                  img: avt,
                  postId: postData['postId'] ?? '',
                  likesList: likesList,
                  repliesList: repliesList,
                  time: postData['timestamp'] ?? '0',
                  id: widget.currentId,
                  creatorId: postData['creatorId'] ?? '',
                );
              },
            );
          },
        );
      },
    );
  }
}
