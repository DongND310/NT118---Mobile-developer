import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  String phone;
  String dob;
  String gender;
  String nation;
  String? avt;
  String? bio;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.dob,
      required this.gender,
      required this.nation,
      required this.bio,
      required this.avt});

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
        id: doc['ID'],
        name: doc['Name'],
        email: doc['Email'],
        phone: doc['Phone'],
        dob: doc['DOB'],
        gender: doc['Gender'],
        nation: doc['Nation'],
        bio: doc['Bio'],
        avt: doc['Avt']);
  }
}
