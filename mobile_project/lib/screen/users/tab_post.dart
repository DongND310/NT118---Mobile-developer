import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/components/post.dart';

class PostTab extends StatefulWidget {
  const PostTab({super.key});

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;
  String? _name;
  String? _id;
  String? _avt;

  @override
  void initState() {
    super.initState();
    getUserData();
    print(user.email);
  }

  void getUserData() async {
    User currentUser = _auth.currentUser!;
    _uid = currentUser.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    _id = userDoc.get('ID');
    _name = userDoc.get('Name');
    _avt = userDoc.get('Avt');
    setState(() {});
    print(_id);
    print(_name);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 0.0, left: 10, right: 0),
      children: [
        SizedBox(height: 10),
        PostDetailScreen(
          name: _id ?? '',
          content:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec consectetur feugiat ex, at gravida tortor elementum eget. Nulla fermentum ultrices dolor in iaculis. Integer consequat quam eu dolor accumsan rutrum.",
          img: _avt,
          imgList: [
            'https://picsum.photos/id/1068/500/500',
            'https://picsum.photos/id/1069/500/500',
            'https://picsum.photos/id/1070/500/500'
          ],
          like: 520,
          reply: 180,
          time: Timestamp.now(),
        ),
        Container(
          height: 0.3,
          color: Colors.grey,
        ),
        SizedBox(height: 10),
        PostDetailScreen(
          name: _id ?? '',
          content:
              "Nullam nisl odio, volutpat quis nulla eget, placerat posuere leo. Pellentesque lobortis ultricies ligula, eget facilisis dui tempor eget. Maecenas ullamcorper orci id nisl maximus sagittis. Suspendisse potenti. Mauris ut mi maximus.",
          img: _avt,
          imgList: [
            'https://picsum.photos/id/1045/500/500',
            'https://picsum.photos/id/1044/500/500',
            'https://picsum.photos/id/1047/500/500',
            'https://picsum.photos/id/1048/500/500',
            'https://picsum.photos/id/1049/500/500',
            'https://picsum.photos/id/1050/500/500',
            'https://picsum.photos/id/1051/500/500',
            'https://picsum.photos/id/1052/500/500',
          ],
          like: 30,
          reply: 11,
          time: Timestamp.fromDate(DateTime(2024, 05, 07)),
        ),
        Container(
          height: 0.3,
          color: Colors.grey,
        ),
        SizedBox(height: 10),
        PostDetailScreen(
          name: _id ?? '',
          content: "Sữa tươi trân châu đường đen 100% đường 100% đá ;D",
          img: _avt,
          imgList: [
            'https://picsum.photos/id/1000/500/500',
            'https://picsum.photos/id/1001/500/500',
            'https://picsum.photos/id/1002/500/500',
            'https://picsum.photos/id/1003/500/500'
          ],
          like: 654,
          reply: 321,
          time: Timestamp.fromDate(DateTime(2024, 05, 05)),
        ),
        Container(
          height: 0.3,
          color: Colors.grey,
        ),
        SizedBox(height: 10),
        PostDetailScreen(
          name: _id ?? '',
          content: "Hello world!",
          img: _avt,
          imgList: [],
          like: 999,
          reply: 999,
          time: Timestamp.fromDate(DateTime(2024, 04, 01)),
        ),
      ],
    );
  }
}
