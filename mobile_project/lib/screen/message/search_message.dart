
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/screen/message/chat_page.dart';

import '../Search/widget/account_detail.dart';

class SearchMessageScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_SearchMessageState();
}

class _SearchMessageState extends State<SearchMessageScreen>{
  TextEditingController _textEditingController = TextEditingController();
  var searchName ="";
  FirebaseAuth _auth = FirebaseAuth.instance;
  FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 30,
          child: TextField(
            controller: _textEditingController,
            focusNode: _focusNode,
            onChanged: (value)
            {
              setState(() {
                searchName = value;
              });
            },
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SvgPicture.asset(
                  'assets/icons/search.svg',
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _textEditingController.clear();
                      _focusNode.unfocus();
                    });
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/cancel.svg',
                  ),
                ),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
      ),
      body:StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .orderBy('Name')
              .startAt([searchName]).endAt([searchName + "\uf8ff"]).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(receiverId: data.id, receiverName: data['Name'],
                          ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: AccountDetail(data['Name'], ""),
                  ),
                );
              },
            );

          }),
    );
  }
  // Widget _buildUserList(){
  //   return StreamBuilder(stream: FirebaseFirestore.instance.collection('users').snapshots(),
  //       builder: (context, snapshot){
  //         if (snapshot.hasError) {
  //           return Text('Something went wrong');
  //         }
  //
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Text("Loading");
  //         }
  //         return ListView(
  //           children: snapshot.data!.docs
  //           .map<Widget>((doc)=> _buildUserListItem(doc)).toList(),
  //         );
  //       }
  //   );
  // }
  // Widget _buildUserListItem(DocumentSnapshot document)
  // {
  //   Map<String, dynamic> data = document.data()! as Map<String,dynamic>;
  //   if(_auth.currentUser!.displayName != data['Name']){
  //     return  GestureDetector(
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => ChatPage(receiverId: data.id, receiverName: data['Name'],
  //             ),
  //           ),
  //         );
  //       },
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //         child: AccountDetail(data['Name'], ""),
  //       ),
  //     );
  //   }
  //   else return Container();
  // }
}