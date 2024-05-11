import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/chat_service.dart';

class ChatBottomSheet extends StatelessWidget {
  final String receiverId;
  final String receiverName;
  final String chatterImg;
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  ChatBottomSheet(
      {required this.receiverId,
      required this.receiverName,
      required this.chatterImg});

  void onSendMessage() async {
    if (_controller.text.isNotEmpty) {
      await _chatService.sendMessage(
          receiverId, receiverName, chatterImg, _controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3))
      ]),
      child: Row(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: IconButton(
                icon: Icon(
                  Icons.emoji_emotions_outlined,
                  size: 30,
                ),
                color: Colors.blue,
                onPressed: () {},
              )),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Container(
              alignment: Alignment.centerRight,
              width: 250,
              child: TextFormField(
                cursorColor: Colors.blue,
                controller: _controller,
                decoration: InputDecoration(
                    hintText: "Type something...", border: InputBorder.none),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 0),
            child: IconButton(
              onPressed: () {
                onSendMessage();
              },
              icon: Icon(
                Icons.send,
                color: Colors.blue,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}
