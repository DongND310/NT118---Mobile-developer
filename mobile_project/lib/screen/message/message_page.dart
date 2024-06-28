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
        automaticallyImplyLeading: false,
        title: const Text(
          "Hộp thư",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchMessageScreen()));
                },
                // icon: SvgPicture.asset('assets/icons/search.svg', width: 30, height: 30,)),
                icon: SvgPicture.asset(
                  'assets/icons/search.svg',
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: const RecentChats(),
    );
  }
}
