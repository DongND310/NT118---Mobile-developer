import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/components/detail_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'proflie_setting.dart';

class DetailProfileScreen extends StatefulWidget {
  DetailProfileScreen({super.key});

  @override
  State<DetailProfileScreen> createState() => _DetailProfileScreenState();
}

class _DetailProfileScreenState extends State<DetailProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;
  String? _name;
  String? _id;
  String? _email;
  String? _dob;
  String? _phone;
  String? _gender;
  String? _nation;

  @override
  void initState() {
    super.initState();
    getUserData();
    print(user.email);
    print(user.uid);
  }

  void getUserData() async {
    User currentUser = _auth.currentUser!;
    _uid = currentUser.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    _id = userDoc.get('ID');
    _name = userDoc.get('Name');
    _email = userDoc.get('Email');
    _dob = userDoc.get('DOB');
    _phone = userDoc.get('Phone');
    _gender = userDoc.get('Gender');
    _nation = userDoc.get('Nation');
    setState(() {});
  }

  String maskString(String input, int count) {
    if (input.length <= 3) {
      return input;
    }
    String maskedPart = input.substring(input.length - count);
    String asterisks = '*' * (input.length - count);
    return '$asterisks$maskedPart';
  }

  @override
  Widget build(BuildContext context) {
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
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileSettingPage(),
              ),
            );
          },
          icon: SvgPicture.asset(
            'assets/icons/ep_back.svg',
            width: 30,
            height: 30,
          ),
        ),
        title: const Text(
          'Tài khoản',
          style: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: ListView(
          padding: const EdgeInsets.only(top: 0.0, left: 20, right: 10),
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 20,
                  ), //Email
                  UserDetailInfo(
                    text: "Email",
                    // change: maskString(_email ?? '', 12),
                    change: _email ?? '',
                    lead: "_email",
                    isChange: false,
                  ),

                  // ID
                  UserDetailInfo(
                    text: "ID người dùng",
                    change: _id ?? '',
                    lead: "_id",
                    isChange: true,
                  ),

                  // pass
                  UserDetailInfo(
                    text: "Mật khẩu",
                    change: "********",
                    lead: "_pass",
                    isChange: true,
                  ),

                  // sdt
                  UserDetailInfo(
                    text: "Số điện thoại",
                    // change: maskString(_phone ?? '', 3),
                    change: _phone ?? '',
                    lead: "_phone",
                    isChange: true,
                  ),

                  // dob
                  UserDetailInfo(
                    text: "Ngày sinh",
                    change: _dob ?? '',
                    lead: "_dob",
                    isChange: true,
                  ),

                  // gender
                  UserDetailInfo(
                    text: "Giới tính",
                    change: _gender ?? '',
                    lead: "_gender",
                    isChange: true,
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
