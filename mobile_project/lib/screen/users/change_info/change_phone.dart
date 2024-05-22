import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/components/detail_change.dart';

class PhoneChangeScreen extends StatelessWidget {
  final String? text;
  final TextEditingController _textEditingController = TextEditingController();
  PhoneChangeScreen({super.key, required this.text});

  // final TextEditingController _textEditingController = TextEditingController();
  final usersCollection = FirebaseFirestore.instance.collection('users');
  Future<void> updateUserData(String data) async {
    try {
      if (data.trim().isNotEmpty) {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await usersCollection.doc(currentUser.uid).update({'Phone': data});
        }
      } else {}
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = text ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.black,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/ep_back.svg',
            width: 30,
            height: 30,
          ),
        ),
        title: const Text(
          'Số điện thoại',
          style: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: GestureDetector(
              onTap: () {
                String data = _textEditingController.text.trim();
                print(data);
                updateUserData(data);
                Navigator.pop(context);
              },
              child: Text(
                'Lưu',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: ListView(
          padding: const EdgeInsets.only(top: 0.0, left: 30, right: 20),
          children: [
            ChangeInfoField(
                label: "Số điện thoại", controller: _textEditingController),
          ],
        ),
      ),
    );
  }
}
