import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_project/models/post_model.dart';

import '../screen/posts_videos/post.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;
  String? _name;
  String? _avt;

  List<PostModel> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      return PostModel(
        postId: doc.id,
        creatorId: data?['creatorId'] ?? '',
        creatorName: data?['creatorName'] ?? '',
        creatorImg: data?['creatorImg'] ?? '',
        content: data?['content'] ?? '',
        timestamp: data?['timestamp'] ?? 0,
      );
    }).toList();
  }

  Future<void> getUserData() async {
    User currentUser = _auth.currentUser!;
    _uid = currentUser.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    _name = userDoc.get('Name');
    _avt = userDoc.get('Avt');
  }

  Future<void> createPost(String postId, String creatorId, String creatorName,
      String creatorImg, String content) async {
    final Timestamp timestamp = Timestamp.now();
    await getUserData();

    // Create post
    PostModel newPost = PostModel(
      postId: '',
      creatorId: creatorId,
      creatorName: creatorName,
      creatorImg: creatorImg,
      content: content,
      timestamp: timestamp,
    );

    DocumentReference docRef =
        await _firestore.collection("posts").add(newPost.toMap());

    String postId = docRef.id;
    // newPost.postId = postId;
    newPost = PostModel(
        postId: postId,
        creatorId: _uid!,
        creatorName: _name!,
        creatorImg: _avt!,
        content: content,
        timestamp: timestamp);
    await docRef.update({'postId': postId});

    await _firestore.collection("posts").doc(postId).set(newPost.toMap());
  }

  Stream<List<PostModel>> getPostsByUser(uid) {
    return _firestore
        .collection('posts')
        .where('creatorId', isEqualTo: uid)
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map(_postListFromSnapshot);
  }
}
