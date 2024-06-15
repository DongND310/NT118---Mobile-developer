
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  void onSendMessage() {
    if (_controller.text.isNotEmpty) {
      _chatService.sendMessage(
        receiverId,
        receiverName,
        _controller.text,
        //chatterImg,
      );
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
            offset: const Offset(0, 3))
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                icon: const Icon(
                  Icons.emoji_emotions_outlined,
                  size: 30,
                ),
                color: Colors.blue,
                onPressed: () {},
              )),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              width: 250,
              child: TextFormField(
                cursorColor: Colors.blue,
                controller: _controller,
                maxLines: 10,
                minLines: 1,
                decoration: const InputDecoration(
                    hintText: "Hãy nhắn gì đi...", border: InputBorder.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 10, right: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  onSendMessage();
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
