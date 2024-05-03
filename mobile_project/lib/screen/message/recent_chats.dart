
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/services/chat_service.dart';

import '../Search/widget/account_detail.dart';
import 'chat_page.dart';

class RecentChats extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _RecentChatState();

}

class _RecentChatState extends State<RecentChats>{
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("chatrooms").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index];
                          return _buildChatRoomList(data);
                        },
                          //children: snapshot.data!.docs.map((doc) => _buildChatRoomList(doc)).toList(),
                        //   Padding(padding: EdgeInsets.symmetric(vertical: 15),
                        //   child: InkWell(
                        //     onTap: (){
                        //       Navigator.push(context, MaterialPageRoute(
                        //           builder: (context) => ChatPage(
                        //           receiverId: receiverId,
                        //           receiverName: receiverName)));
                        //     },
                        //     child: Container(
                        //       height: 65,
                        //       child: Row(
                        //         children: [
                        //           ClipRRect(
                        //             borderRadius: BorderRadius.circular(35),
                        //             child: Image.network(
                        //               'https://i.pinimg.com/736x/fd/7f/48/fd7f480aa83946195f004f34a0da9ad8.jpg',
                        //               height: 65,
                        //               width: 65,
                        //             ),
                        //           ),
                        //           Padding(padding: EdgeInsets.symmetric(horizontal:20 ),
                        //             child: Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Text(data['messages']['receiverName'],
                        //                   style: TextStyle(
                        //                       fontSize: 18,
                        //                       fontWeight: FontWeight.bold,
                        //                       color: Color(0xFF000141)
                        //                   ),),
                        //                 SizedBox(height: 5),
                        //                 Container(
                        //                   width: MediaQuery.of(context).size.width * 0.5,
                        //                   child: Text.rich(
                        //                     TextSpan(
                        //                       text: message,
                        //                       style: TextStyle(
                        //                         fontSize: 16,
                        //                         color: Colors.black54,
                        //                       ),
                        //                     ),
                        //                     overflow: TextOverflow.ellipsis,
                        //                     maxLines: 1,
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //           Spacer(),
                        //           Padding(padding: const EdgeInsets.only(right: 10),
                        //             child: Column(
                        //               crossAxisAlignment: CrossAxisAlignment.center,
                        //               children: [
                        //                 Text(messages['timestamp'], style: TextStyle(fontSize: 15,color: Colors.black54),),
                        //                 SizedBox(
                        //                   height: 10,
                        //                 ),
                        //                 Container(
                        //                   height: 23,
                        //                   width: 23,
                        //                   alignment: Alignment.center,
                        //                   decoration: BoxDecoration(
                        //                       color: Color(0xFF001141),
                        //                       borderRadius: BorderRadius.circular(25)
                        //                   ),
                        //                   child:Text("1",style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),) ,
                        //                 )
                        //               ],
                        //             ),)
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // );
                        // return GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => ChatPage(
                        //             chatRoomId: chatRoomId(/*_auth.currentUser!.uid*/"yX7uruOnLJKiVc5oTwqS","U1pvS9rs2EgfLbCex4v7"), userMap:data.data() as Map<String, dynamic>
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   child: Padding(
                        //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        //     child: AccountDetail(data['Name'], ""),
                        //   ),
                        // );
                      )
                  );
                },
              ),
            ]
        )
    );
  }
  Widget _buildChatRoomList(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String,
        dynamic>;
    if (data['chatroomId'].contains(_auth.currentUser!.uid)) {
      String chatRoomId = data['chatroomId'];
      return StreamBuilder<QuerySnapshot>(
          stream: _chatService.getMessage(chatRoomId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var datamessage = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatPage(receiverId:
                                  datamessage['receiverId'],
                                    receiverName: datamessage['receiverName'],
                                  ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: AccountDetail(datamessage['receiverName'], datamessage['message']),
                        ),

                      );
                    }
                )

            );
          });
    }

    return Container(
        child:  Text("Lỗi rồiiiiiiiiiiii"));
  }
}
