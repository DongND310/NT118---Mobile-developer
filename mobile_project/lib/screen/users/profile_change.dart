import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/components/detail_profile.dart';
import 'package:mobile_project/components/inputtext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'change_info/change_avt.dart';
import 'profile_page.dart';

class ChangeProfilePage extends StatefulWidget {
  ChangeProfilePage({super.key});

  @override
  State<ChangeProfilePage> createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;
  String? _name;
  String? _id;
  String? _avt;
  String? _bio;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    User currentUser = _auth.currentUser!;
    _uid = currentUser.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    _id = userDoc.get('ID');
    _name = userDoc.get('Name');
    _avt = userDoc.get('Avt');
    _bio = userDoc.get('Bio');
    _uid = userDoc.get('UID');
    // _name = userDoc.get('Name');
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
                builder: (context) => ProfileScreen(
                  currentUserId: _uid!,
                ),
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
          'Chỉnh sửa trang cá nhân',
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ảnh đại diện',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AvtChangeScreen(),
                                ),
                              );
                            },
                            child: Text('Chỉnh sửa',
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 15)),
                          ),
                          SizedBox(width: 20)
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _avt != null
                        ? NetworkImage(_avt!)
                        : Image.asset('assets/images/default_avt.png').image,
                  ),

                  const SizedBox(height: 30),
                  Container(
                    height: 0.3,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 30),

                  // ID
                  UserDetailInfo(
                    text: "Tên người dùng",
                    change: _name ?? '',
                    lead: "_name",
                  ),

                  // nation
                  UserDetailInfo(
                    text: "Tiểu sử",
                    change: _bio ?? '',
                    lead: "_bio",
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
