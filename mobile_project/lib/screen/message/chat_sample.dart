import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatSample extends StatelessWidget{
  String message;

  ChatSample(this.message);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(right: 80),
        child: ClipPath(
          clipper: UpperNipMessageClipper(MessageType.receive),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFE1E1E2),

            ),
            child: Text("Xin chào cả nhà yêu của kem!", style: TextStyle(fontSize: 16),),
          ),
        ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child:  Padding(padding: EdgeInsets.only(top: 20, left:100),
            child: ClipPath(
              clipper: UpperNipMessageClipper(MessageType.send),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF107BFD),
                ),
                child: Text(message , style: TextStyle(fontSize: 16,color: Colors.white),),
              ),
            ),
          ),
        )
      ],
    );
  }

}