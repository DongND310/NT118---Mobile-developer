import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import '../../models/user_model.dart';
import '../../services/database_services.dart';
import '../Search/widget/account_detail.dart';

class SearchMessageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchMessageState();
}

class _SearchMessageState extends State<SearchMessageScreen> {
  final DatabaseServices _databaseServices = DatabaseServices();
  final TextEditingController _textEditingController = TextEditingController();
  String _searchQuery = '';
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/ep_back.svg',
            width: 30,
            height: 30,
          ),
        ),
        title: SizedBox(
          height: 35,
          child: TextField(
            controller: _textEditingController,
            onChanged: (value) {
              setState(() {
                _searchQuery = removeDiacritics(_textEditingController.text).toLowerCase();
              });
            },
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _databaseServices.listFollower(user.uid),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
           if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Text('Không có dữ liệu.');
          } else {
            List<String> listFollowerUids = snapshot
                .data!.docs
                .map((doc) => doc.id)
                .toList();
            return ListView.builder(
              physics:
              const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listFollowerUids.length,
              itemBuilder: (context, index) {
                String uid = listFollowerUids[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: followingsRef
                      .doc(user.uid)
                      .collection("userFollowings")
                      .doc(uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot>
                      followingSnapshot) {
                    if (followingSnapshot
                        .connectionState ==
                        ConnectionState.waiting) {
                      return Container();
                    } else if (!followingSnapshot
                        .hasData ||
                        !followingSnapshot
                            .data!.exists) {
                      return Container();
                    } else {
                      return FutureBuilder<
                          DocumentSnapshot>(
                        future: usersRef.doc(uid).get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<
                                DocumentSnapshot>
                            userSnapshot) {
                          if (userSnapshot
                              .connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          } else if (!userSnapshot
                              .hasData) {
                            return Container();
                          } else {
                            UserModel userModel =
                            UserModel.fromDoc(
                                userSnapshot.data!);
                            String name =
                            removeDiacritics(
                                userModel.name)
                                .toLowerCase();
                            if (_searchQuery.isNotEmpty && !name.contains(_textEditingController.text.toLowerCase())) {
                              return Container();
                            }
                            return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                child: AccountDetail(
                                  userModel.name,
                                  userModel.bio ?? '',
                                  userModel.avt ?? '',
                                )
                            );
                          }
                        },
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
      // body: StreamBuilder<QuerySnapshot>(
      //     stream: FirebaseFirestore.instance
      //         .collection('users')
      //         .orderBy('Name')
      //         .startAt([searchName])
      //         .endAt([searchName + "\uf8ff"])
      //         .where('Name', isNotEqualTo: _auth.currentUser!.displayName)
      //         .snapshots(),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasError) {
      //         return const Text('Có lỗi xảy ra.');
      //       }
      //
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return const Text("Loading");
      //       }
      //       return ListView.builder(
      //         itemCount: snapshot.data!.docs.length,
      //         itemBuilder: (context, index) {
      //           var data = snapshot.data!.docs[index];
      //           return GestureDetector(
      //             onTap: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => ChatPage(
      //                     receiverId: data.id,
      //                     receiverName: data['Name'],
      //                     chatterImg: data['Avt'] ?? 'assets/images/default_avt.png' ,
      //                   ),
      //                 ),
      //               );
      //             },
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      //               child: AccountDetail(data['Name'], "",
      //                   data['Avt'] ?? 'assets/images/default_avt.png'),
      //             ),
      //           );
      //         },
      //       );
      //     }),
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


