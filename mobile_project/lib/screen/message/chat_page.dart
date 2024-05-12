import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/services/chat_service.dart';

import 'chat_bottom_sheet.dart';
import 'chat_sample.dart';
import 'more_chat.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String chatterImg;

  ChatPage(
      {required this.receiverId,
      required this.receiverName,
      required this.chatterImg});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _controller = ScrollController();
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _controller.jumpTo(_controller.position.maxScrollExtent);});
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/ep_back.svg',
              color: Colors.white,
              width: 30,
              height: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.chatterImg != null
                    ? NetworkImage(widget.chatterImg)
                    : Image.asset('assets/images/default_avt.png').image,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: SizedBox(
                  width: 170,
                  child: Text(
                    widget.receiverName,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MoreScreen(
                                  receiverName: widget.receiverName,
                                  receiverId: widget.receiverId,
                                  chatterImg: widget.chatterImg,
                                )));
                  },
                  icon: Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _chatService.getMessages(_auth.currentUser!.uid, widget.receiverId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _controller.jumpTo(_controller.position.maxScrollExtent);
            });
            return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _controller,
              //shrinkWrap: true,
              padding:
                  EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 80),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> map =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return ChatSample(map: map);
              },
            );
          } else {
            return Container();
          }
        },
      ),
      bottomSheet: ChatBottomSheet(
          receiverId: widget.receiverId,
          receiverName: widget.receiverName,
          chatterImg: widget.chatterImg),
    );
  }
}
