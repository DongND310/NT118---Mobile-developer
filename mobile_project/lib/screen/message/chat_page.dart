import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/services/chat_service.dart';

import 'chat_bottom_sheet.dart';
import 'chat_sample.dart';
import 'more_chat.dart';
class ChatPage extends StatelessWidget{
  final String receiverId;
  final String receiverName;
  final ScrollController _controller = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ChatPage({required this.receiverId, required this.receiverName});
  final ChatService _chatService =ChatService();

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _controller.jumpTo(_controller.position.maxScrollExtent);});
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
                  child: Text(receiverName,style: TextStyle(color: Color(0xFF000144),fontWeight: FontWeight.bold)),
                )
              ],
            ),
            actions: [
              Padding(padding: EdgeInsets.only(right: 25),
                  child:
                  IconButton(onPressed: () { Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MoreScreen(userName: receiverName,)));
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatService.getMessages(_auth.currentUser!.uid, receiverId),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _controller.jumpTo(_controller.position.maxScrollExtent);
            });
            return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _controller,
              //shrinkWrap: true,
              padding: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 80),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> map = snapshot.data!.docs[index]
                    .data() as Map<String, dynamic>;
                return ChatSample( map: map);
              },
            );

          } else {
            return Text("error");//Container();
          }
        },
      ),
      bottomSheet: ChatBottomSheet(receiverId: receiverId, receiverName: receiverName,),
    );
  }

}