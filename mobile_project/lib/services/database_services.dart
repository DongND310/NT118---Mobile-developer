import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/constants.dart';

class DatabaseServices {
  static Future<int> followersNum(String userID) async {
    QuerySnapshot followersSnapshot =
        await followersRef.doc(userID).collection('userFollowers').get();
    return followersSnapshot.docs.length;
  }

  static Future<int> followingNum(String userID) async {
    QuerySnapshot followingSnapshot =
        await followingRef.doc(userID).collection('userFollowing').get();
    return followingSnapshot.docs.length;
  }
}
