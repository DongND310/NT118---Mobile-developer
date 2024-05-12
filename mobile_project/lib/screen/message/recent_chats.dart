import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_project/services/chat_service.dart';
import 'chat_page.dart';

class RecentChats extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecentChatState();
}

class _RecentChatState extends State<RecentChats> {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // String timestampToHourMinuteString(Timestamp timestamp) {
  //   DateTime dateTime = timestamp.toDate();
  //
  //   return DateFormat.Hm().format(dateTime);// Hm tương ứng với "HH:mm"
  // }
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inHours < 24) {
      return DateFormat.Hm().format(dateTime);
      ;
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
              if (snapshot.hasError) {
                return Text('Có lỗi xảy ra.');
              }
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
                        if (snapshot.connectionState == ConnectionState.waiting) {
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
//   String _getAvt (String id) {
//   final DocumentSnapshot userDoc = FirebaseFirestore.instance.collection('users').doc(id).get() as DocumentSnapshot<Object?>;
//   return userDoc.get('Avt');
// }
  Future<Widget> _buildChatRoomList(DocumentSnapshot documentSnapshot) async {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    if (data['chatroomId'].contains(_auth.currentUser!.uid)) {
      String chatRoomId = data['chatroomId'];
      return StreamBuilder<QuerySnapshot>(
          stream: _chatService.getMessage(chatRoomId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Có lỗi xảy ra.');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var datamessage = snapshot.data!.docs[0];
            bool isSender = false;
            if (datamessage['senderId'] == _auth.currentUser!.uid) {
              isSender = true;
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => isSender
                          ? ChatPage(
                              receiverId: datamessage['receiverId'],
                              receiverName: datamessage['receiverName'],
                              chatterImg: data["imageUser1"],
                            )
                          : ChatPage(
                              receiverId: datamessage['senderId'],
                              receiverName: datamessage['senderName'],
                              chatterImg: data["imageUser2"],
                            ),
                    ),
                  );
                },
                child: Container(
                  height: 65,
                  child: Row(
                    children: [
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(35),
                      //   child: Image.network(
                      //     'https://i.pinimg.com/736x/fd/7f/48/fd7f480aa83946195f004f34a0da9ad8.jpg',
                      //     height: 65,
                      //     width: 65,
                      //   ),
                      // ),

                      CircleAvatar(
                        radius: 30,
                        backgroundImage: isSender? NetworkImage(data['imageUser1']) :
                            NetworkImage(data['imageUser2']!)
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
                              child: Text(
                                  isSender
                                      ? datamessage['receiverName']
                                      : datamessage['senderName'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text.rich(
                                TextSpan(
                                  text: isSender
                                      ? "Bạn: " + datamessage['message']
                                      : datamessage['message'],
                                  style: TextStyle(
                                    fontSize: 16,
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
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              formatTimestamp(datamessage['timestamp']),
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black54),
                            ),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
    return Container();
  }
}
