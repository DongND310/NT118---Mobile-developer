import 'dart:developer';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/constants.dart';

class DatabaseServices {

  Stream<QuerySnapshot> listFollower(String userId) {
    return followersRef
        .doc(userId)
        .collection("userFollowers")
        .snapshots();
  }
  Future<QuerySnapshot> listFollowing(String userId) async {
    Future<QuerySnapshot> listFollowings = followingsRef
        .doc(userId)
        .collection("userFollowings")
        .get();
    return listFollowings;
  }
  static Future<QuerySnapshot> searchUsers(String name) async {
    Future<QuerySnapshot> users = usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: name + 'z')
        .get();

    return users;
  }
}
