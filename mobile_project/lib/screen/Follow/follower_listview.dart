import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/constants.dart';
import 'package:mobile_project/screen/Follow/search_bar.dart';
import 'package:mobile_project/screen/users/profile_page.dart';
import 'package:mobile_project/services/database_services.dart';
import '../../models/user_model.dart';
import '../Search/widget/account_detail.dart';
import '../message/chat_page.dart';

class ListFollowerScreen extends StatefulWidget {
  const ListFollowerScreen(
      {super.key,
      required this.currentUserId,
      required this.tabIndex,
      required this.followerNum,
      required this.followingNum});
  final String currentUserId;
  final int tabIndex;
  final int followerNum;
  final int followingNum;
  @override
  State<StatefulWidget> createState() => _ListFollowerState();
}

class _ListFollowerState extends State<ListFollowerScreen> {
  String _searchQuery = '';
  int _tabIndex = 0;
  int _followingNum = 0;
  int _followerNum = 0;
  int _friendNum =0;

  final TextEditingController _textEditingController = TextEditingController();
  final DatabaseServices _databaseServices = DatabaseServices();
  String? _uid;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    _tabIndex = widget.tabIndex;
    _uid = widget.currentUserId;
    _followerNum = widget.followerNum;
    _followingNum = widget.followingNum;
    getFriendCount();
  }
  void getFriendCount() {
    followersRef
        .doc(widget.currentUserId)
        .collection("userFollowers")
        .get()
        .then((followersSnapshot) {
      List<String> followersList = followersSnapshot.docs.map((doc) => doc.id).toList();

      followingsRef
          .doc(widget.currentUserId)
          .collection("userFollowings")
          .get()
          .then((followingSnapshot) {
        List<String> followingList = followingSnapshot.docs.map((doc) => doc.id).toList();
        Set<String> followersSet = Set<String>.from(followersList);
        Set<String> followingSet = Set<String>.from(followingList);
        Set<String> friendsSet = followersSet.intersection(followingSet);
        setState(() {
          _friendNum = friendsSet.length;
        });
      });
    });
  }

  void _searchName(String query) {
    setState(() {
      _searchQuery = removeDiacritics(query).toLowerCase();
    });
  }

  Future<bool> checkFollowing(String uerId) async {
    DocumentSnapshot doc = await followingsRef
        .doc(widget.currentUserId)
        .collection("userFollowings")
        .doc(uerId)
        .get();
    return doc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: _tabIndex,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
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
            bottom: TabBar(
              tabs: [
                Tab(text: 'Follower $_followerNum'),
                Tab(text: "Following $_followingNum"),
                Tab(text: "Bạn bè $_friendNum"),
              ],
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SearchFollowerBar(_searchName, _textEditingController),
                      StreamBuilder<QuerySnapshot>(
                          stream: _databaseServices.listFollower(_uid!),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Text('Không có follower');
                            } else {
                              List<String> listFollowerUids = snapshot
                                  .data!.docs
                                  .map((doc) => doc.id)
                                  .toList();
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listFollowerUids.length,
                                itemBuilder: (context, index) {
                                  String uid = listFollowerUids[index];
                                  return FutureBuilder<bool>(
                                    future: checkFollowing(uid),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<bool> followingSnapshot) {
                                      if (followingSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      } else if (followingSnapshot.hasError) {
                                        return Text('Error: ${followingSnapshot.error}');
                                      } else {
                                        bool isFollow = followingSnapshot.data ?? false;
                                        return FutureBuilder(
                                            future: usersRef.doc(uid).get(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
                                              if (!snapshot.hasData) {
                                                return Container();
                                              }
                                              UserModel userModel =
                                              UserModel.fromDoc(snapshot.data);
                                              String name =
                                              removeDiacritics(userModel.name)
                                                  .toLowerCase();
                                              if (_searchQuery.isNotEmpty &&
                                                  !name.contains(
                                                      _textEditingController.text
                                                          .toLowerCase())) {
                                                return Container();
                                              }
                                              return Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child:
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ( ProfileScreen(visitedUserID:userModel.uid ,currentUserId: widget.currentUserId,)
                                                          ),
                                                        ));
                                                      },
                                                      child: AccountDetail(
                                                          userModel.name,
                                                          userModel.bio ?? '',
                                                          userModel.avt ?? ''),
                                                    )
                                                  ),
                                                  buildProfileButton(isFollow, uid)
                                                ],
                                              );
                                            });
                                      }
                                    });
                                },
                              );
                            }
                          })
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SearchFollowerBar(_searchName, _textEditingController),
                      StreamBuilder<QuerySnapshot>(
                          stream: _databaseServices.listFollowing(_uid!),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Text('Bạn đang không theo dõi ai!');
                            } else {
                              List<String> listFollowingUids = snapshot
                                  .data!.docs
                                  .map((doc) => doc.id)
                                  .toList();
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listFollowingUids.length,
                                itemBuilder: (context, index) {
                                  String uid = listFollowingUids[index];
                                  return FutureBuilder(
                                      future: usersRef.doc(uid).get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        }
                                        UserModel userModel =
                                            UserModel.fromDoc(snapshot.data);

                                        String name =
                                            removeDiacritics(userModel.name)
                                                .toLowerCase();
                                        if (_searchQuery.isNotEmpty &&
                                            !name.contains(
                                                _textEditingController.text
                                                    .toLowerCase())) {
                                          return Container();
                                        }
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                        ( ProfileScreen(visitedUserID:userModel.uid ,currentUserId: widget.currentUserId,)
                                                        ),
                                                      ));
                                                },
                                                child: AccountDetail(
                                                    userModel.name,
                                                    userModel.bio ?? '',
                                                    userModel.avt ?? ''),
                                              ),
                                            ),
                                            buildProfileButton(true, uid)
                                          ],
                                        );
                                      });
                                },
                              );
                            }
                          })
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                  child: widget.currentUserId == user.uid
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              SearchFollowerBar(
                                  _searchName, _textEditingController),
                              StreamBuilder<QuerySnapshot>(
                                stream: _databaseServices.listFollower(_uid!),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return const Text('Không có dự liệu');
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
                                              .doc(widget.currentUserId)
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
                                                    if (_searchQuery
                                                            .isNotEmpty &&
                                                        !name.contains(
                                                            _textEditingController
                                                                .text
                                                                .toLowerCase())) {
                                                      return Container();
                                                    }
                                                    return Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                    ( ProfileScreen(visitedUserID:userModel.uid ,currentUserId: widget.currentUserId,)
                                                                    ),
                                                                  ));
                                                            },
                                                            child: AccountDetail(
                                                                userModel.name,
                                                                userModel.bio ?? '',
                                                                userModel.avt ?? ''),
                                                          )
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.push(context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ChatPage(
                                                                    receiverId: uid,
                                                                    receiverName: userModel.name,
                                                                    chatterImg: userModel.avt ?? 'assets/images/default_avt.png' ,
                                                                  ),
                                                                ));
                                                          },
                                                          style: ButtonStyle(
                                                            minimumSize: MaterialStateProperty.all<Size>(
                                                              const Size(125, 35),
                                                            ),
                                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                              ),
                                                            ),
                                                          ),
                                                          child: const Text('Nhắn tin',),
                                                        )
                                                      ],
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
                              )
                            ],
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Text(
                            "Bạn không có quyền xem danh sách này!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        )),
            ],
          ),
        ));
  }
  //final currentUser = FirebaseAuth.instance.currentUser!;

   handleUnfollowUser(String userId) {
     followersRef
         .doc(userId)
         .collection('userFollowers')
         .doc(widget.currentUserId)
         .get()
         .then((doc) {
       if (doc.exists) {
         doc.reference.delete();
       }
     });
     followingsRef
         .doc(widget.currentUserId)
         .collection('userFollowings')
         .doc(userId)
         .get()
         .then((doc) {
       if (doc.exists) {
         doc.reference.delete();
       }
     });
     DocumentReference userRef =
     FirebaseFirestore.instance.collection('users').doc(widget.currentUserId);

     userRef.update({
       'followingsList': FieldValue.arrayRemove([userId])
     }).then((_) {
       setState(() {
         _followingNum -= 1;
         getFriendCount();
       });
       });
  }

  handleFollowUser(String userId, bool isFollowing) {
    followersRef
        .doc(userId)
        .collection('userFollowers')
        .doc(widget.currentUserId)
        .set({});

    followingsRef
        .doc(widget.currentUserId)
        .collection('userFollowings')
        .doc(userId)
        .set({});
    DocumentReference userRef =
    FirebaseFirestore.instance.collection('users').doc(widget.currentUserId);
    userRef.update({
      'followingsList': FieldValue.arrayUnion([userId])
    }).then((_) {
      setState(() {
        _followingNum += 1;
        getFriendCount();
      });
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
}
