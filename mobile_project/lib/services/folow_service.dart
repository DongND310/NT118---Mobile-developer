import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
class FollowService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> Follow(String followerId, String followedId) async {
    String followed_user_id = followedId;
    DocumentSnapshot FollowSnapshot =
    await _firestore.collection("follows").doc(followed_user_id).get();
    if (!FollowSnapshot.exists) {
      _firestore.collection("follows").doc(followed_user_id).set({
        "followed_user_id": followedId, //người được follow
        "following_user_id": followerId //người ấn follow
      });
    }
  }

  Future<void> Unfollow(String followerId, String followedId) async {
    String followed_user_id = followedId;
    DocumentSnapshot FollowSnapshot =
    await _firestore.collection("follows").doc(followed_user_id).get();
    if (!FollowSnapshot.exists) {
      _firestore.collection("follows").doc(followed_user_id).delete();
    }
  }
}