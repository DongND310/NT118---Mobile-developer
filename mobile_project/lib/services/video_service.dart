import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_project/models/video_model.dart';

class VideoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;
  String? _name;
  String? _avt;

  List<VideoModel> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      return VideoModel(
        videoId: doc.id,
        postedById: data?['postedById'] ?? '',
        caption: data?['caption'] ?? '',
        videoUrl: data?['videoUrl'] ?? '',
        timestamp: data?['timestamp'] ?? 0,
        ref: doc.reference,
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

  Future<void> createVideoPost(String videoId, String postedById,
      String caption, String videoUrl) async {
    final Timestamp timestamp = Timestamp.now();
    await getUserData();

    // Create video
    VideoModel newVideoPost = VideoModel(
      videoId: '',
      postedById: postedById,
      caption: caption,
      videoUrl: videoUrl,
      timestamp: timestamp,
    );

    DocumentReference docRef =
        await _firestore.collection("videos").add(newVideoPost.toMap());

    String videoId = docRef.id;
    newVideoPost = VideoModel(
        videoId: videoId,
        postedById: _uid!,
        caption: caption,
        videoUrl: videoUrl,
        timestamp: timestamp);
    await docRef.update({'videoId': videoId});

    await _firestore
        .collection("videos")
        .doc(videoId)
        .set(newVideoPost.toMap());
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;

  final usersCollection = FirebaseFirestore.instance.collection('videos');
  final user = FirebaseAuth.instance.currentUser!;

  Future<String> uploadVideoToStorage(String videoUrl) async {
    try {
      Reference ref =
          _storage.ref().child('video/${user.uid}_${DateTime.now()}.mp4');
      await ref.putFile(File(videoUrl));
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Upload thất bại: $e");
      throw Exception("Upload thất bại: $e");
    }
  }

  Future<void> saveVideoData(String videoUrl) async {
    await usersCollection.add({
      'userID': user.uid,
      'userName': user.displayName,
      'videoUrl': videoUrl,
      'createdAt': DateTime.now(),
    });
  }
}
