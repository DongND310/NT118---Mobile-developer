import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/screen/users/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/chat_service.dart';

class MoreScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String chatterImg;

  MoreScreen(
      {required this.receiverId,
      required this.receiverName,
      required this.chatterImg});
  @override
  State<StatefulWidget> createState() => _MoreState();
}

class _MoreState extends State<MoreScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool _isPressed = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationState();
  }

  void _loadNotificationState() async {
    ChatService chatService = ChatService();
    bool isPressed = await chatService.getNotificationState(user!.uid, widget.receiverId);
    setState(() {
      _isPressed = isPressed;
    });
  }
  void _saveNotificationState(bool value) async {
    ChatService chatService = ChatService();
    chatService.setNotificationState(value, user!.uid, widget.receiverId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/ep_back.svg',
              width: 30,
              height: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 0.0, left: 40, right: 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: widget.chatterImg != null
                    ? NetworkImage(widget.chatterImg)
                    : Image.asset('assets/images/default_avt.png').image,
              ),
              const SizedBox(
                height: 35,
              ),
              Text(
                widget.receiverName,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>
                                    ProfileScreen(currentUserId: user!.uid, visitedUserID: widget.receiverId)));
                          },
                          icon: const Icon(
                            Icons.account_circle_outlined,
                            color: Color(0xFF107BFD),
                            size: 40,
                          )),
                      const Text(
                        "Trang cá nhân",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.blue),
                      )
                    ],
                  ),
                  // SizedBox(
                  //   width: 100,
                  // ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _isPressed = !_isPressed;
                              _saveNotificationState(_isPressed);
                            });
                          },
                          icon: _isPressed
                              ? const Icon(
                                  Icons.notifications_none_outlined,
                                  color: Color(0xFF107BFD),
                                  size: 40,
                                )
                              : const Icon(
                                  Icons.notifications_off_outlined,
                                  color: Color(0xFF107BFD),
                                  size: 40,
                                )),
                      Text(
                        _isPressed ? "Tắt thông báo" : "Bật thông báo",
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.blue),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}
