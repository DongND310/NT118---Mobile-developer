import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _textEditingController = TextEditingController();
  bool _showClearButton = false;

  String? _uid;
  String? _name;
  String? _id;
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
    _id = userDoc.get('ID');
    _name = userDoc.get('Name');
    _avt = userDoc.get('Avt');
    setState(() {});
  }

  void _updateClearButtonVisibility(String value) {
    setState(() {
      _showClearButton = value.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color.fromARGB(255, 107, 206, 242),
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
                  Navigator.pop(context);
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
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // avt
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: _avt != null
                      ? NetworkImage(_avt!)
                      : Image.asset('assets/images/default_avt.png').image,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
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
                        ]),
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
                          )),
                      style: const TextStyle(fontSize: 16),
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        _updateClearButtonVisibility(value);
                      },
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                    // interact icon
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/post_img.svg',
                          width: 22,
                          // color: Colors.blue,
                        ),
                        const SizedBox(width: 18),
                        SvgPicture.asset(
                          'assets/icons/post_hashtag.svg',
                          width: 22,
                          // color: Colors.blue,
                        ),
                      ],
                    ),
                  ])),
            ])));
  }
}
