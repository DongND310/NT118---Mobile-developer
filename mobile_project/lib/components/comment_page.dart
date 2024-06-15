import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_project/components/custom_comment.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final comment = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: Container(
        color: Colors.white,
        height: 300,
        child: Stack(
          children: [
            Positioned(
                top: 8,
                left: 155,
                child: Container(width: 90, height: 2, color: Colors.grey)),

            //
            ListView(
              padding: const EdgeInsets.only(
                  top: 20, left: 15, right: 25, bottom: 50),
              children: [
                CustomComment(
                    name: "user1",
                    img: '',
                    content: "Thật bổ x",
                    like: 10,
                    reply: 5,
                    time: Timestamp.fromDate(DateTime(2024, 05, 07))),
                CustomComment(
                    name: "user2",
                    img: '',
                    content: "Thấy cũng bình thường",
                    like: 99,
                    reply: 45,
                    time: Timestamp.fromDate(DateTime(2024, 05, 21))),
                CustomComment(
                    name: "user3",
                    img: '',
                    content: "Nhiêu đó cũng khoe",
                    like: 456,
                    reply: 123,
                    time: Timestamp.fromDate(DateTime(2024, 05, 23))),
                CustomComment(
                    name: "user4",
                    img: '',
                    content:
                        "Thay vì dành thời gian làm mấy cái này thì tui đi ngủ còn hơn",
                    like: 999,
                    reply: 999,
                    time: Timestamp.fromDate(DateTime(2024, 05, 22))),
                CustomComment(
                    name: "user5",
                    img: '',
                    content: "Đi ngủ đi",
                    like: 102,
                    reply: 15,
                    time: Timestamp.fromDate(DateTime(2024, 05, 15)))
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: _avt != null
                            ? NetworkImage(_avt!)
                            : Image.asset('assets/images/default_avt.png')
                                .image,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 270,
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 30),
                            child: TextField(
                              controller: comment,
                              autofocus: false,
                              maxLines: 10,
                              minLines: 1,
                              cursorColor: Colors.blue,
                              decoration: const InputDecoration(
                                hintText: "Thêm bình luận",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _showClearButton = value.isNotEmpty;
                                });
                              },
                            ),
                          ),
                          if (_showClearButton)
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 18,
                                ),
                                onPressed: () {
                                  comment.clear();
                                  setState(() {
                                    _showClearButton = false;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
