import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/services/chat_service.dart';

class ChatSample extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Map<String, dynamic> map;
  final ChatService chatService;

  ChatSample({required this.map, required this.chatService});

  @override
  _ChatSampleState createState() => _ChatSampleState();
}

class _ChatSampleState extends State<ChatSample> {
  @override
  void initState() {
    super.initState();
    if (!widget.map.containsKey('read') && widget.map['receiverId'] == widget._auth.currentUser!.uid) {
      widget.chatService.updateMessageReadStatus(
          widget.map['senderId'],
          widget.map['receiverId'],
          widget.map['messageId']
      ).then((_) {
        setState(() {
          widget.map['read'] = DateTime.now().millisecondsSinceEpoch.toString();
        });
      });
    }
  }

  Widget whiteMessage() {
    if(!widget.map.containsKey('read') && widget.map['receiverId'] == widget._auth.currentUser!.uid) {
      widget.chatService.updateMessageReadStatus(
          widget.map['senderId'],
          widget.map['receiverId'],
          widget.map['messageId']
      );
    }
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 80),
        child: ClipPath(
          clipper: UpperNipMessageClipper(
            MessageType.receive,
            bubbleRadius: 20,
            sizeOfNip: 0,
          ),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Color(0xFFE1E1E2),
            ),
            child: Text(
              widget.map['message'],
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  Widget blueMessage() {
    return Container(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 100),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.map.containsKey('read') && widget.map['read'] != ''
                ? const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20)
                : Container(),
            const SizedBox(width: 20),
            ClipPath(
              clipper: UpperNipMessageClipper(
                MessageType.send,
                bubbleRadius: 20,
                sizeOfNip: 0,
              ),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  widget.map['message'],
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.map['senderId'] != widget._auth.currentUser!.uid
        ? whiteMessage()
        : blueMessage();
  }
}
