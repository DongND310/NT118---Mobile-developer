// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// final FirebaseStorage _storage = FirebaseStorage.instance;
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// final usersCollection = FirebaseFirestore.instance.collection('videos');
// final user = FirebaseAuth.instance.currentUser!;

// class StoreDataVideo {
//   Future<String> uploadVideoToStorage(String videoUrl) async {
//     Reference ref =
//         _storage.ref().child('video/${user.uid}_${DateTime.now()}.mp4');
//     await ref.putFile(File(videoUrl));
//     String downloadUrl = await ref.getDownloadURL();
//     return downloadUrl;
//   }

//   Future<void> saveVideoData(String videoDownloadUrl) async {
//     await _firestore.collection('videos').add({
//       'videoUrl': videoDownloadUrl,
//     });

//     String resp = " Có lỗi xảy ra.";
//     try {
//       String videoDownloadUrl = await uploadVideoToStorage(
//           '${user.uid}_${Timestamp.now()}.mp4');

//       await _firestore
//           .collection('videos')
//           .doc(videos.)
//           .update({'Avt': imageUrl});

//       resp = 'success';
//     } catch (err) {
//       resp = err.toString();
//     }
//   }
// }
