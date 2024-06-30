import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/constants.dart';
import 'package:mobile_project/models/user_model.dart';
import 'package:mobile_project/screen/Search/widget/video_search.dart';
import 'package:mobile_project/services/database_services.dart';

import '../../users/profile_page.dart';
import '../hashtagview.dart';
import 'account_detail.dart';
import 'hashtag.dart';

class SearchResult extends StatefulWidget {
  final String query;
  final String name;
  final String currentId;

  const SearchResult(
      {super.key, required this.query,
        required this.name,
        required this.currentId});


  @override
  State<StatefulWidget> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  late final String _query;
  late final String _name;
  late final String _uid;
  final DatabaseServices databaseServices = DatabaseServices();
  @override
  void initState() {
    super.initState();
    setState(() {
      _query= widget.query.toLowerCase();
      _uid = widget.currentId;
      _name = widget.name;
    });
  }
  Future<bool> checkFollowing(String uerId) async {
    DocumentSnapshot doc = await followingsRef
        .doc(widget.currentId)
        .collection("userFollowings")
        .doc(uerId)
        .get();
    return doc.exists;
  }
  handleUnfollowUser(String userId) {
    followersRef
        .doc(userId)
        .collection('userFollowers')
        .doc(widget.currentId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    followingsRef
        .doc(widget.currentId)
        .collection('userFollowings')
        .doc(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    DocumentReference userRef =
    FirebaseFirestore.instance.collection('users').doc(widget.currentId);
    userRef.update({
      'followingsList': FieldValue.arrayRemove([userId])
    }).then((_) {
      setState(() {
      });
    });
  }

  handleFollowUser(String userId, bool isFollowing) {
    followersRef
        .doc(userId)
        .collection('userFollowers')
        .doc(widget.currentId)
        .set({});

    followingsRef
        .doc(widget.currentId)
        .collection('userFollowings')
        .doc(userId)
        .set({});
    DocumentReference userRef =
    FirebaseFirestore.instance.collection('users').doc(widget.currentId);
    userRef.update({
      'followingsList': FieldValue.arrayUnion([userId])
    });
  }
  buildProfileButton(bool isFollowing, String userId) {
    if (isFollowing) {
      return buildButton(
          text: "Unfollow",
          isFollowing: isFollowing,
          function: () {
            handleUnfollowUser(userId);
            setState(() {
              isFollowing = false;
            });
          });

    } else {
      return buildButton(
          text: "Follow",
          isFollowing: isFollowing,
          function: () {
            handleFollowUser(userId, isFollowing);
            setState(() {
              isFollowing = true;
            });
          });
    }
  }

  ElevatedButton buildButton(
      {required String text,
        required bool isFollowing,
        required VoidCallback function}) {
    return ElevatedButton(
      onPressed: function,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(125, 35),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
            isFollowing ? Colors.grey : Colors.blue),
        foregroundColor: MaterialStateProperty.all<Color>(
            isFollowing ? Colors.black : Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      child: Text(text,),
    );
  }
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
        initialIndex: 0,
        length: 4,
        child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: "Thịnh hành"),
                  Tab(text: "Tài khoản"),
                  Tab(text: "Video"),
                  Tab(text: "Hashtag"),
                ],
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.blue,
                labelColor: Colors.blue,
              ),
              Expanded(
                  child:TabBarView(children: [
                    SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                  stream: usersRef
                                      .orderBy('Name')
                                      .startAt([_query])
                                      .endAt(["$_query\uf8ff"])
                                      .where('Name', isNotEqualTo: _name)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if(snapshot.connectionState==ConnectionState.waiting){
                                      return Container();
                                    }else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                      return const Text("Không có gì để tìm");
                                    }
                                    else {
                                      UserModel user = UserModel.fromDoc(snapshot.data!.docs[0]);
                                      return FutureBuilder<bool>(
                                        future: checkFollowing(user.uid),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<bool> followingSnapshot) {
                                          if (followingSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container();
                                          } else if (followingSnapshot.hasError) {
                                            return Text('Error: ${followingSnapshot.error}');
                                          } else {
                                            bool isFollow = followingSnapshot.data ?? false;
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Padding(padding: EdgeInsets.only(top: 10, bottom: 10),
                                                    child:Text(
                                                      "Tài khoản",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    )
                                                ),
                                                Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      Expanded(child:
                                                      GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                  ( ProfileScreen(visitedUserID:user.uid ,currentUserId: _uid)
                                                                  ),
                                                                ));
                                                          },
                                                          child:AccountDetail(user.name, user.bio??'', user.avt ?? '')
                                                      ),),
                                                      buildProfileButton(isFollow, user.uid)
                                                    ]
                                                )
                                              ],
                                            );
                                          }
                                        },
                                      );
                                    }}),
                              const SizedBox(height: 15),
                              const Text(
                                "Video",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisExtent: 220,
                                ),
                                itemCount: 3,
                                itemBuilder: (BuildContext context, int index) {
                                  return VideoSearch(
                                    "hihi",
                                    "30",
                                    "hihiihi",
                                  );
                                },
                              ),
                            ],
                          ),
                        )),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: usersRef
                                        .orderBy('Name')
                                        .startAt([_query])
                                        .endAt(["$_query\uf8ff"])
                                        .where('Name', isNotEqualTo: _name)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if(snapshot.connectionState==ConnectionState.waiting){
                                        return Container();
                                      }else if(!snapshot.hasData){
                                        return Container();
                                      }
                                      else
                                      {
                                        List<String> listUids = snapshot
                                            .data!.docs
                                            .map((doc) => doc.id)
                                            .toList();
                                        return  ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: listUids.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              UserModel user = UserModel.fromDoc(snapshot.data!.docs[index]);
                                              return FutureBuilder<bool>(
                                                future: checkFollowing(user.uid),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<bool> followingSnapshot) {
                                                  if (followingSnapshot.connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Container();
                                                  } else if (followingSnapshot.hasError) {
                                                    return Text('Error: ${followingSnapshot.error}');
                                                  } else {
                                                    bool isFollow = followingSnapshot.data ?? false;
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                            children: [
                                                              Expanded(child:
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                          ( ProfileScreen(visitedUserID:user.uid ,currentUserId: _uid)
                                                                          ),
                                                                        ));
                                                                  },
                                                                  child:AccountDetail(user.name, user.bio??'', user.avt ?? '')
                                                              ),),
                                                              buildProfileButton(isFollow, user.uid)
                                                            ]
                                                        )
                                                      ],
                                                    );
                                                  }
                                                },
                                              );

                                            });
                                      }
                                    }
                                )
                            )
                          ]),
                    ),
                    Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: GridView.builder(
                            physics: const PageScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 218,
                            ),
                            itemCount: 20,
                            itemBuilder: (BuildContext context, int index) {
                              return VideoSearch(
                                "widget.title",
                                "10",
                                "account",
                              );
                            },
                          ),
                        )),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: SizedBox(
                                height: 50 ,
                                child: ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemExtent: 70,
                                    itemCount: 20,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => const HashTagScreen(
                                                        "hashtag nè")));
                                          },
                                          child: Hashtag("hashtag nè"));
                                    }),
                              )),
                        ],
                      ),
                    )
                  ]
                  )
              )
            ])
    );
  }
  // Widget buildVideo()
  // {
  //   return FutureBuilder(
  //     future:usersRef
  //         .where('name', isGreaterThanOrEqualTo: query)
  //         .where('name', isLessThan: '${query}z')
  //         .limit(1).get() ,
  //     builder: (context, snapshot) {
  //       if(snapshot.connectionState==ConnectionState.waiting){
  //         return Container();
  //       }else if(!snapshot.hasData){
  //         return Container();
  //       }
  //       else
  //       {
  //         UserModel user = UserModel.fromDoc(snapshot.data!.docs[0]);
  //         return AccountDetail(user.name, user.bio??'', user.avt ?? '');
  //       }
  //     },
  //   );
  // }
}