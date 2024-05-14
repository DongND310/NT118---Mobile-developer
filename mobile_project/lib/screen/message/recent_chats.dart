import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_project/services/chat_service.dart';
import '../../constants.dart';
import '../../models/user_model.dart';
import 'chat_page.dart';

class RecentChats extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecentChatState();
}

class _RecentChatState extends State<RecentChats> {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inHours < 24) {
      return DateFormat.Hm().format(dateTime);
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 365) {
      int months = difference.inDays ~/ 30;
      return '${months}mo';
    } else {
      int years = difference.inDays ~/ 365;
      return '${years}y';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("chatrooms").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  for (var doc in snapshot.data!.docs)
                    FutureBuilder(
                      future: _buildChatRoomList(doc),
                      builder: (context, AsyncSnapshot<Widget> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(); // or any loading indicator
                        }
                        return snapshot.data!;
                      },
                    ),
                ],
              ));
        },
      ),
    ]));
  }

  Future<Widget> _buildChatRoomList(DocumentSnapshot documentSnapshot) async {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    if (data['chatroomId'].contains(_auth.currentUser!.uid)) {
      String chatRoomId = data['chatroomId'];
      return StreamBuilder<QuerySnapshot>(
          stream: _chatService.getLastMessage(chatRoomId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Có lỗi xảy ra.');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            var datamessage = snapshot.data!.docs[0];
            bool isSender = false;
            if (datamessage["senderId"] == _auth.currentUser!.uid) {
              isSender = true;
            }
            return FutureBuilder(
                future: usersRef
                    .doc(isSender
                        ? datamessage["receiverId"]
                        : datamessage["senderId"])
                    .get(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  UserModel userModel = UserModel.fromDoc(snapshot.data);
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                    receiverId: userModel.uid,
                                    receiverName: userModel.name,
                                    chatterImg: userModel.avt ?? '',
                                  )),
                        );
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(userModel.avt ?? '')),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(userModel.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                  ),
                                  SizedBox(height: 5),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        text: isSender
                                            ? "Bạn: " + datamessage['message']
                                            : datamessage['message'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Align(
                              alignment: Alignment.topRight,
                              child: Expanded(
                                child: Text(
                                  formatTimestamp(datamessage['timestamp']),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          });
    }
    return Container();
  }
}
