import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/components/navigation_container.dart';
import 'package:mobile_project/services/post_service.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PostService _postService = PostService();

  TextEditingController _textEditingController = TextEditingController();
  bool _showClearButton = false;
  String content = '';

  String? _uid;
  String? _name;
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
    _name = userDoc.get('Name');
    _avt = userDoc.get('Avt');
    setState(() {});
  }

  void _updateClearButtonVisibility(String value) {
    setState(() {
      _showClearButton = value.isNotEmpty;
    });
  }

  Future<void> _createPost() async {
    try {
      await _postService.createPost('', _uid!, content);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bài viết đã được đăng thành công!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationContainer(
            currentUserID: user.uid,
            pageIndex: 0,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng bài thất bại: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Thêm bài viết',
          style: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: GestureDetector(
              onTap: () {
                if (content != "") {
                  _createPost();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vui lòng nhập nội dung bài viết')),
                  );
                }
              },
              child: const Text(
                'Đăng',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20, right: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: _avt != null
                    ? NetworkImage(_avt!)
                    : Image.asset('assets/images/default_avt.png').image,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _name ?? '',
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                      if (_showClearButton)
                        Container(
                          width: 40,
                          height: 25,
                          child: IconButton(
                            icon: Icon(Icons.clear),
                            padding: const EdgeInsets.only(
                                right: 10, top: 0, bottom: 0),
                            iconSize: 15,
                            onPressed: () {
                              _textEditingController.clear();
                              _updateClearButtonVisibility('');
                            },
                          ),
                        ),
                    ],
                  ),
                  TextField(
                    autofocus: true,
                    maxLines: 10,
                    minLines: 1,
                    cursorColor: Colors.blue,
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Có gì mới?',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    style: const TextStyle(fontSize: 16),
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      setState(() {
                        content = value;
                      });
                      _updateClearButtonVisibility(value);
                    },
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
