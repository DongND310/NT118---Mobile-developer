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
        content: data?['content'] ?? '',
        // likesList: data?['likesList'],
        // likeCount: data?['likeCount'] ?? 0,
        replyCount: data?['replyCount'],
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
      content: content,
      // likesList: [],
      // likeCount: 0,
      replyCount: 0,
      timestamp: timestamp,
    );

    DocumentReference docRef =
        await _firestore.collection("posts").add(newPost.toMap());

    String postId = docRef.id;
    newPost = PostModel(
        postId: postId,
        creatorId: _uid!,
        content: content,
        // likesList: [],
        // likeCount: 0,
        replyCount: 0,
        timestamp: timestamp);
    await docRef.update({'postId': postId});

    await _firestore.collection("posts").doc(postId).set(newPost.toMap());
  }

  Future<void> likePost(PostModel post, bool isDisLike) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final likeRef = _firestore
        .collection("posts")
        .doc(post.postId)
        .collection("likes")
        .doc(userId);

    if (isDisLike) {
      await likeRef.delete();
    } else {
      await likeRef.set({
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<bool> getCurrentUserLike(PostModel post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.postId)
        .collection("likes")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
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
