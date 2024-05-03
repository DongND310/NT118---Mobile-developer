import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/services/chat_service.dart';

class ChatSample extends StatelessWidget{
  final Map<String,dynamic> map;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ChatSample({ required this.map});
  @override
  Widget build(BuildContext context) {
    return map['senderId']!= _auth.currentUser!.uid?
    Container(
      alignment: Alignment.centerLeft,
      child: Padding(padding: EdgeInsets.only(right: 80),
        child: ClipPath(
          clipper: UpperNipMessageClipper(MessageType.receive),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFE1E1E2),
            ),
            child: Text(map['message'], style: TextStyle(fontSize: 16),),
          ),
        ),
      )
    )
       : Container(
          alignment: Alignment.centerRight,
          child:  Padding(padding: EdgeInsets.only(top: 20, left:100),
            child: ClipPath(
              clipper: UpperNipMessageClipper(MessageType.send),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF107BFD),
                ),
                child: Text(map['message'] , style: TextStyle(fontSize: 16,color: Colors.white),),
              ),
            ),
          ),
        );
  }

}