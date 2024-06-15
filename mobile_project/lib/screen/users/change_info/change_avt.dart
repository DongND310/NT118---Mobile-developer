import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_project/_mock_data/mock.dart';
import 'package:mobile_project/components/detail_change.dart';
import 'package:mobile_project/models/user_model.dart';
import 'package:mobile_project/util/imagepicker.dart';

import '../profile_change.dart';
import '../profile_page.dart';

class AvtChangeScreen extends StatefulWidget {
  String? text;

  AvtChangeScreen({super.key});

  @override
  State<AvtChangeScreen> createState() => _AvtChangeScreenState();
}

class _AvtChangeScreenState extends State<AvtChangeScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  //final usersCollection = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;
  String? _avt;

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
    // _avt = userDoc.get('Avt');
    // setState(() {});
    if (mounted) {
      setState(() {
        _avt = userDoc.get('Avt');
      });
    }
  }

  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateProfileImg() async {
    try {
      String resp = await StoreData().saveData(file: _image!);
      if (resp == 'success') {
        print('Đã cập nhật ảnh lên Firebase Storage và Firestore');
      } else {
        print('Lỗi khi cập nhật ảnh: $resp');
      }
    } catch (e) {
      print('Lỗi không mong muốn khi cập nhật ảnh: $e');
    }
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
          onPressed: () async {
            // Navigator.pop(context, true);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeProfilePage(),
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
          'Ảnh đại diện',
          style: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: GestureDetector(
              onTap: () async {
                await updateProfileImg();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeProfilePage(),
                  ),
                );
              },
              child: const Text(
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
          padding: const EdgeInsets.only(top: 0.0, left: 30, right: 30),
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 50),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 100,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 100,
                              backgroundImage: _avt != null
                                  ? NetworkImage(_avt!)
                                  : Image.asset('assets/images/default_avt.png')
                                      .image,
                            ),
                      Positioned(
                        bottom: 10,
                        left: 140,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 30,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 50),
                ]),
          ],
        ),
      ),
    );
  }
}
