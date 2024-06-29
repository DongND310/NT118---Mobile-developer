import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatSample extends StatelessWidget{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Map<String, dynamic> map;
  ChatSample({required this.map});

@override
  Widget build(BuildContext context) {
    return  map['senderId'] != _auth.currentUser!.uid
        ? Container(
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
                map['message'],
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
        ))
        : Container(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 100),
        child: ClipPath(
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
              map['message'],
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    )
    ;
  }
}
