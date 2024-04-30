import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'chat_bottom_sheet.dart';
import 'chat_sample.dart';
import 'more_chat.dart';
class ChatPage extends StatelessWidget{
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);});
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Padding(
          padding: EdgeInsets.only(top: 5),
          child: AppBar(
            leading: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/ep_back.svg',
                width: 30,
                height: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    'https://i.pinimg.com/736x/fd/7f/48/fd7f480aa83946195f004f34a0da9ad8.jpg',
                    height: 45,
                    width: 45,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 10),
                  child: Text("Ái Thủy",style: TextStyle(color: Color(0xFF000144),fontWeight: FontWeight.bold)),
                )
              ],
            ),
            actions: [
              Padding(padding: EdgeInsets.only(right: 25),
                  child:
                  IconButton(onPressed: () { Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MoreScreen()));
                  },
                    icon: Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF107BFD),
                      size: 30,
                    ),
                  )
              )
            ],
          ),
        ),
      ),
      body: ListView(
        controller: _controller,
        padding: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 80),
        children: [
          ChatSample("Hihihihihihihihihihihihihi, có gì không vậy? hahahahahaha"),
          ChatSample("Hihihihihihihihihihihihihi, có gì không vậy? hahahahahaha"),
          ChatSample("Hihihihihihihihihihihihihi, có gì không vậy? hahahahahaha"),
          ChatSample("Hihihihihihihihihihihihihi, có gì không vậy? hahahahahaha"),
          ChatSample("Hihihihihihihihihihihihihi, có gì không vậy? hahahahahaha"),
          ChatSample("Hihihihihihihihihihihihihi, có gì không vậy? hahahahahaha"),
        ],
      ),
      bottomSheet: ChatBottomSheet(),
    );
  }

}