import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/constants.dart';

class DatabaseServices {
  static Future<int> followersNum(String userID) async {
    try {
      QuerySnapshot querySnapshot = await followsRef
          .where('followed_user_id', isEqualTo: userID)
          .get();
      return querySnapshot.size;
    } catch (e) {
      print("Error getting followers: $e");
      return 0;
    }
  }

  static Future<int> followingNum(String userID) async {
    try {
      QuerySnapshot querySnapshot = await followsRef
          .where('following_user_id', isEqualTo: userID)
          .get();
      return querySnapshot.size;
    } catch (e) {
      print("Error getting followers: $e");
      return 0;
    }
  }
  static Future<bool> isFollowing(String followedID, String followingID) async {
    try {
      QuerySnapshot querySnapshot = await followsRef
          .where('following_user_id', isEqualTo: followingID)
      .where('followed_user_id', isEqualTo: followedID)
          .get();
      if(querySnapshot.size==0) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      log("Error getting followers: $e");
      return false;
    }
  }

  static Future<QuerySnapshot> searchUsers(String name) async {
    Future<QuerySnapshot> users = usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: name + 'z')
        .get();

    return users;
  }
}
