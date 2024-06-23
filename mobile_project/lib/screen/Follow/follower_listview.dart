import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/constants.dart';
import 'package:mobile_project/screen/Follow/search_bar.dart';
import 'package:mobile_project/services/database_services.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart';
import '../Search/widget/account_detail.dart';

class ListFollowerScreen extends StatefulWidget {
  ListFollowerScreen({super.key, required this.currentUserId, required this.tabIndex, required this.followerNum, required this.followingNum});
  final String currentUserId;
  final int tabIndex;
  final int followerNum;
  final int followingNum;
  @override
  State<StatefulWidget> createState() => _ListFollowerState();
}

class _ListFollowerState extends State<ListFollowerScreen> {
  bool _isPressed = false;
  String _searchQuery = '';
  int _tabIndex=0;
  int _followingNum=0;
  int _followerNum=0;
  final TextEditingController _textEditingController = TextEditingController();
  final DatabaseServices _databaseServices = DatabaseServices();
  String? _uid;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    _tabIndex =widget.tabIndex;
    _uid = widget.currentUserId;
    _followerNum = widget.followerNum;
    _followingNum = widget.followingNum;
  }
  void _searchName(String query) {
    setState(() {
      _searchQuery = removeDiacritics(query).toLowerCase();
    });
  }

  checkFollowing(String uerId) async {
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
                Tab(text: "Bạn bè 11K"),
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
                      SearchFollowerBar(_searchName,_textEditingController),
                      StreamBuilder<QuerySnapshot>(
                          stream: _databaseServices.listFollower(_uid!),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Text('Không có follower');
                            } else {
                              List <String> listFollowerUids = snapshot.data!.docs.map((doc) => doc.id).toList();
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listFollowerUids.length,
                                itemBuilder: (context, index) {
                                  String uid =listFollowerUids[index];
                                  return FutureBuilder(future: usersRef.doc(uid).get(),
                                      builder: (BuildContext context, AsyncSnapshot snapshot)
                                      {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        }
                                        UserModel userModel = UserModel.fromDoc(snapshot.data);
                                        String name = removeDiacritics(userModel.name).toLowerCase();
                                        if(_searchQuery.isNotEmpty&& !name.contains(_textEditingController.text.toLowerCase()))
                                        {
                                          return Container();
                                        }
                                        return Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: AccountDetail(
                                                  userModel.name,
                                                  userModel.bio??'',
                                                  userModel.avt ?? ''),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                // setState(() {
                                                //   _isPressed = !_isPressed;
                                                // });
                                              },
                                              style: ButtonStyle(
                                                minimumSize: MaterialStateProperty.all<Size>(
                                                  const Size(125, 35),
                                                ),
                                                backgroundColor: MaterialStateProperty.all<
                                                    Color>(
                                                    _isPressed ? Colors.grey : Colors.blue),
                                                foregroundColor: MaterialStateProperty.all<
                                                    Color>(
                                                    _isPressed ? Colors.black : Colors.white),
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                ),
                                              ),
                                              child: const Text('Follow'),
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                },
                              );
                            }
                          }
                      )
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SearchFollowerBar(_searchName,_textEditingController),
                      StreamBuilder<QuerySnapshot>(
                          stream: _databaseServices.listFollowing(_uid!),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Text('Bạn đang không theo dõi ai!');
                            } else {
                              List <String> listFollowingUids = snapshot.data!.docs.map((doc) => doc.id).toList();
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listFollowingUids.length,
                                itemBuilder: (context, index) {
                                  String uid =listFollowingUids[index];
                                  return FutureBuilder(future: usersRef.doc(uid).get(),
                                      builder: (BuildContext context, AsyncSnapshot snapshot)
                                      {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        }
                                        UserModel userModel = UserModel.fromDoc(snapshot.data);
                                        String name = removeDiacritics(userModel.name).toLowerCase();
                                        if(_searchQuery.isNotEmpty&& !name.contains(_textEditingController.text.toLowerCase()))
                                          {
                                            return Container();
                                          }
                                        return Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: AccountDetail(
                                                  userModel.name,
                                                  userModel.bio??'',
                                                  userModel.avt ?? ''),
                                            ),

                                            // ElevatedButton(
                                            //   onPressed: () {
                                            //     // setState(() {
                                            //     //   _isPressed = !_isPressed;
                                            //     // });
                                            //   },
                                            //   style: ButtonStyle(
                                            //     minimumSize: MaterialStateProperty.all<Size>(
                                            //       const Size(125, 35),
                                            //     ),
                                            //     backgroundColor: MaterialStateProperty.all<
                                            //         Color>(
                                            //         _isPressed ? Colors.grey : Colors.blue),
                                            //     foregroundColor: MaterialStateProperty.all<
                                            //         Color>(
                                            //         _isPressed ? Colors.black : Colors.white),
                                            //     shape: MaterialStateProperty.all<
                                            //         RoundedRectangleBorder>(
                                            //       RoundedRectangleBorder(
                                            //         borderRadius: BorderRadius.circular(5),
                                            //       ),
                                            //     ),
                                            //   ),
                                            //   child: const Text('Follow'),
                                            // ),
                                          ],
                                        );
                                      }
                                  );
                                },
                              );
                            }
                          }
                      )
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: widget.currentUserId == user.uid?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SearchFollowerBar(_searchName,_textEditingController),
                      StreamBuilder<QuerySnapshot>(
                        stream: _databaseServices.listFollower(_uid!),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return const Text('Không có bạn');
                          } else {
                            List<String> listFollowerUids = snapshot.data!.docs.map((doc) => doc.id).toList();
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
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
                                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> followingSnapshot) {
                                    if (followingSnapshot.connectionState == ConnectionState.waiting) {
                                      return Container();
                                    }
                                    else if (!followingSnapshot.hasData || !followingSnapshot.data!.exists) {
                                      return Container();
                                    }
                                    else {
                                      return FutureBuilder<DocumentSnapshot>(
                                        future: usersRef.doc(uid).get(),
                                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                                            return Container();
                                          }
                                          else if (!userSnapshot.hasData) {
                                            return Container();
                                          }
                                          else {
                                            UserModel userModel = UserModel.fromDoc(userSnapshot.data!);
                                            bool _isFollow= true;
                                            String name = removeDiacritics(userModel.name).toLowerCase();
                                            if (_searchQuery.isNotEmpty && !name.contains(_textEditingController.text.toLowerCase())) {
                                              return Container();
                                            }
                                            return Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: AccountDetail(
                                                    userModel.name,
                                                    userModel.bio ?? '',
                                                    userModel.avt ?? '',
                                                  ),
                                                ),
                                                buildProfileButton(_isFollow, uid),
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
                ):
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text("Bạn không có quyền xem danh sách này!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
              ),
            ],
          ),
        ));
  }
  handleUnfollowUser(String userId) async {
    followersRef.doc(widget.currentUserId)
        .collection('userFollowers')
        .doc(userId)
        .get()
        .then((doc) {
      if(doc.exists)
      {
        doc.reference.delete();
      }
    });
    followingsRef.doc(userId)
        .collection('userFollowings')
        .doc(widget.currentUserId)
        .get()
        .then((doc) {
      if(doc.exists)
      {
        doc.reference.delete();
      }
    });
  }

  handleFollowUser(String userId) {
    followersRef.doc(userId)
        .collection('userFollowers')
        .doc(widget.currentUserId)
        .set({});

    followingsRef.doc(widget.currentUserId)
        .collection('userFollowings')
        .doc(userId)
        .set({});

  }
  buildProfileButton(bool isFollowing, String userId) {
    if (isFollowing) {
      return buildButton(text: "Unfollow",isFollowing: isFollowing, function: handleUnfollowUser(userId));
    } else {
      return buildButton(text: "Follow", isFollowing: isFollowing,function: handleFollowUser(userId));
    }
  }
  Container buildButton(
      {required String text,required bool isFollowing, required VoidCallback function}) {
    return Container(
        child: ElevatedButton(
          onPressed: function,
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(
              const Size(125, 35),
            ),
            backgroundColor: MaterialStateProperty.all<
                Color>(
                isFollowing ? Colors.grey : Colors.blue),
            foregroundColor: MaterialStateProperty.all<
                Color>(
                isFollowing ? Colors.black : Colors.white),
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          child: const Text('Follow'),
        ),
    );
  }
}
