import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/models/user_model.dart';
import 'package:mobile_project/services/utils.dart';

class UserService {
  UtilsService _utilsService = UtilsService();

  UserModel _userFromFirebaseSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot.id,
      id: data['ID'] ?? '',
      name: data['Name'] ?? '',
      email: data['Email'] ?? '',
      phone: data['Phone'] ?? '',
      dob: data['DOB'] ?? '',
      gender: data['Gender'] ?? '',
      bio: data['Bio'] ?? '',
      avt: data['Avt'] ??
          'https://i.pinimg.com/564x/21/0a/76/210a7677d78d6dcedccbf1c543aa7ebf.jpg',
    );
  }

  Stream<UserModel> getUserInfo(uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .map(_userFromFirebaseSnapshot);
  }

  Future<void> updateProfile(File img, String name) async {
    String _img = '';

    if (_img != null) {
      //
    }

    Map<String, Object> data = new HashMap();

    if (name != '') data['name'] = name;
    if (img != '')
      data['img'] = await _utilsService.uploadFile(
          img, "user/profile/${FirebaseAuth.instance.currentUser!.uid}");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
  }
}
