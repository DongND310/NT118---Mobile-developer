import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/components/detail_change.dart';

class NameChangeScreen extends StatelessWidget {
  final String? text;
  final TextEditingController _textEditingController = TextEditingController();

  NameChangeScreen({super.key, required this.text});

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
          'Tên người dùng',
          style: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: ListView(
          padding: const EdgeInsets.only(top: 0.0, left: 30, right: 30),
          children: [
            ChangeInfoField(label: "Tên", controller: _textEditingController),
            const SizedBox(height: 10),
            Text(
              "Bạn chỉ có thể đổi tên người dùng của tài khoản 1 lần trong vòng 30 ngày.",
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
