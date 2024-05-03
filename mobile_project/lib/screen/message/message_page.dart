import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/screen/message/recent_chats.dart';
import 'package:mobile_project/screen/message/search_message.dart';

class MessagePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hộp thư",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF000141))),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SearchMessageScreen()));
                },
                icon: SvgPicture.asset('assets/icons/search.svg')),
          )
        ],
      ),
      // body: ListView(
      //   children: [
      //     Padding(
      //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      //         child: RecentChats())
      //   ],
      // ),
      body: RecentChats(),
    );
  }
}
