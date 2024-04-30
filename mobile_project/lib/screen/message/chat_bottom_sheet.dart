import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBottomSheet extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3)
          )
        ]
      ),
      child: Row(
        children: [
          Padding(padding: EdgeInsets.only(left: 10),
            child: IconButton(
              icon: Icon(Icons.emoji_emotions_outlined,size: 30,),
              color: Color(0xFF000144), onPressed: () {  },
            )
          ),
          Padding(padding: EdgeInsets.only(left: 20),
          child: Container(
            alignment: Alignment.centerRight,
            width: 270,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Type something...",
                  border: InputBorder.none
                ),
              ),
          ),
          ),
          Padding(padding: EdgeInsets.only(right: 10),
          child: IconButton(onPressed: () {  },
            icon: Icon(Icons.send, color: Color(0xFF000144),size: 30,),
          ),)
        ],
      ),
    );
  }

}