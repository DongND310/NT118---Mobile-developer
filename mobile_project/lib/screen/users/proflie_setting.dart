import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/components/navigation_container.dart';
import 'package:mobile_project/screen/login-regis/welcome.dart';

import 'profile_change.dart';
import 'profile_detail.dart';
import 'profile_page.dart';

class ProfileSettingPage extends StatefulWidget {
  ProfileSettingPage({super.key});

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
  }

  Future<void> ConfirmSignOut() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Cảnh báo!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Bạn có chắc chắn muốn đăng xuất không?',
            style: TextStyle(fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Đăng xuất',
                    style: TextStyle(color: Colors.red, fontSize: 17)),
                onPressed: () {
                  signUserOut();
                }),
            SizedBox(
              width: 10,
            ),
            TextButton(
              child: const Text('Hủy',
                  style: TextStyle(color: Colors.blue, fontSize: 17)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

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
    _uid = userDoc.get('UID');
    setState(() {});
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
          'Cài đặt',
          style: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: ListView(
          padding: const EdgeInsets.only(top: 0.0, left: 30, right: 20),
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 20,
                  ),

                  // person
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/st_person.svg',
                            width: 25,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            'Tài khoản',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailProfileScreen()));
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  // privacy
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/st_privacy.svg',
                            width: 25,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            'Quyền riêng tư',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => PersonProfileScreen()));
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  // info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/st_info.svg',
                            width: 25,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            'Giới thiệu',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => PersonProfileScreen()));
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  // log out
                  const SizedBox(
                    height: 30,
                  ),

                  GestureDetector(
                    onTap: () {
                      ConfirmSignOut();
                      print(user.email);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/st_logout.svg',
                          width: 25,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'Đăng xuất',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
