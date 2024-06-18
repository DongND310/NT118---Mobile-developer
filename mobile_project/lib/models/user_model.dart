import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  String id;
  String uid;
  String name;
  String email;
  String phone;
  String dob;
  String gender;
  String? avt;
  String? bio;

  UserModel(
      {required this.uid,
      required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.dob,
      required this.gender,
      required this.bio,
      required this.avt});

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
        uid: doc['UID'],
        id: doc['ID'],
        name: doc['Name'],
        email: doc['Email'],
        phone: doc['Phone'],
        dob: doc['DOB'],
        gender: doc['Gender'],
        bio: doc['Bio'],
        avt: doc['Avt']);
  }
}

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final usersCollection = FirebaseFirestore.instance.collection('users');
final user = FirebaseAuth.instance.currentUser!;

class StoreData {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({required Uint8List file}) async {
    String resp = " Có lỗi xảy ra.";
    try {
      String imageUrl =
          await uploadImageToStorage('${user.uid}_profileImage', file);

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'Avt': imageUrl});

      resp = 'success';
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}
