import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/screen/message/recent_chats.dart';

class MessagePage extends StatelessWidget
{
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
          onPressed: () {},
        ),
        title: Text("Hộp thư",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Color(0xFF000141))),
        centerTitle: true,
        actions: [
          Padding(padding: EdgeInsets.only(right: 15),
          child: IconButton(onPressed: (){},
              icon: SvgPicture.asset('assets/icons/search.svg',
                width: 30,
                height: 30,)
          ),)
        ],
      ),
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            child: RecentChats()
          )
        ],
      ),
    );
  }
}

