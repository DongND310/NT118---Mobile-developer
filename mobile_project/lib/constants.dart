import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const kPrimaryColor1 = Color(0x0BA9FFFF);
const kPrimaryColor2 = Color(0x107BFDFF);
const kPrimaryColor3 = Color(0x0000D7FF);
const kPrimaryColor4 = Color(0x000141FF);

final _fireStore = FirebaseFirestore.instance;
final usersRef = _fireStore.collection('users');
final videoRef = _fireStore.collection('videos');
final followersRef = _fireStore.collection('followers');
final followingsRef = _fireStore.collection('followings');

