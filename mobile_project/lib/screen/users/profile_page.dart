import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/constants.dart';
import 'package:mobile_project/models/user_model.dart';
import 'package:mobile_project/screen/Follow/follower_listview.dart';
import 'change_info/change_avt.dart';
import 'profile_change.dart';
import 'proflie_setting.dart';
import 'tab_like.dart';
import 'tab_post.dart';
import 'tab_save.dart';
import 'tab_video.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen(
      {super.key, required this.currentUserId, required this.visitedUserID});
  final String currentUserId;
  final String visitedUserID;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool _isVisited;
  bool _isFollowing = false;
  int _followersCount = 0;
  int _followingCount = 0;
  int _userfollowingCount = 0;

  getFollowersCount() async {
    QuerySnapshot snapshot = await followersRef
        .doc(widget.visitedUserID)
        .collection("userFollowers")
        .get();
    if (mounted) {
      setState(() {
        _followersCount = snapshot.docs.length;
      });
    }
  }

  getFollowingCount() async {
    QuerySnapshot snapshot = await followingsRef
        .doc(widget.visitedUserID)
        .collection("userFollowings")
        .get();
    if (mounted) {
      setState(() {
        _followingCount = snapshot.docs.length;
      });
    }
  }

  checkFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(widget.visitedUserID)
        .collection("userFollowers")
        .doc(widget.currentUserId)
        .get();
    setState(() {
      _isFollowing = doc.exists;
    });
  }

  UserModel? userModel;

  Future<void> getUserData() async {
    DocumentSnapshot doc = await usersRef.doc(widget.visitedUserID).get();
    setState(() {
      userModel = UserModel.fromDoc(doc);
    });
  }

  @override
  void initState() {
    super.initState();
    _isVisited = widget.currentUserId != widget.visitedUserID;
    _tabController = TabController(length: !_isVisited ? 4 : 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    checkFollowing();
    getFollowersCount();
    getFollowingCount();
    getUserData();

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
          List<dynamic> followingsList = data?['followingsList'];
          _userfollowingCount = followingsList.length;
        });
      }
    });
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: usersRef.doc(widget.visitedUserID).get(),
          // future: usersRef.doc(widget.currentUserId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              );
            }
            UserModel userModel = UserModel.fromDoc(snapshot.data);
            return DefaultTabController(
              length: !_isVisited ? 4 : 2,
              child: NestedScrollView(
                  headerSliverBuilder: (context, index) {
                    return [
                      SliverAppBar(
                        leading: Visibility(
                            visible: _isVisited,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/ep_back.svg',
                                width: 30,
                                height: 30,
                              ),
                            )),
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                        pinned: true,
                        floating: true,
                        snap: true,
                        backgroundColor: Colors.white,
                        elevation: 0.5,
                        title: Text(
                          userModel.id,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        actions: [
                          Visibility(
                              visible: !_isVisited,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileSettingPage(),
                                    ),
                                  );
                                },
                                icon: SvgPicture.asset(
                                  'assets/icons/setting_list.svg',
                                  width: 18,
                                ),
                              )),
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          color: Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                // avatar + userID
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AvtChangeScreen(),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: userModel.avt != null
                                        ? NetworkImage(userModel.avt!)
                                        : Image.asset(
                                                'assets/images/default_avt.png')
                                            .image,
                                  ),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  userModel.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),

                                // follow
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, left: 40, right: 45),
                                  child: Row(
                                    children: [
                                      // following
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    !_isVisited
                                                        ? ListFollowerScreen(
                                                            tabIndex: 1,
                                                            currentUserId: widget
                                                                .visitedUserID,
                                                            followerNum:
                                                                _followersCount,
                                                            followingNum:
                                                                _userfollowingCount,
                                                          )
                                                        : ListFollowerScreen(
                                                            tabIndex: 1,
                                                            currentUserId: widget
                                                                .visitedUserID,
                                                            followerNum:
                                                                _followersCount,
                                                            followingNum:
                                                            _userfollowingCount,
                                                          ), // update following
                                              ),
                                            );
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                !_isVisited
                                                    ? '$_userfollowingCount'
                                                    : '$_followingCount',
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Text(
                                                'Following',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // follower
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ListFollowerScreen(
                                                  tabIndex: 0,
                                                  currentUserId:
                                                      widget.visitedUserID,
                                                  followerNum: _followersCount,
                                                  followingNum: _followingCount,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '$_followersCount',
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Text(
                                                'Follower',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),

                                // btn edit profile
                                !_isVisited
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangeProfilePage(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 45,
                                          width: 260,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.blue),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 0.5,
                                                blurRadius: 8,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Chỉnh sửa hồ sơ',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          buildProfileButton(),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileSettingPage(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 55,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.blue),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 0.5,
                                                    blurRadius: 8,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Nhắn tin',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                // bio
                                const SizedBox(
                                  height: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, left: 40, right: 45),
                                  child: Text(
                                    userModel.bio ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(193, 0, 0, 0),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ]),
                        ),
                      ),
                      !_isVisited
                          ? SliverPersistentHeader(
                              pinned: true,
                              floating: false,
                              delegate: _SliverAppBarDelegate(
                                TabBar(
                                  controller: _tabController,
                                  tabs: [
                                    Tab(
                                      icon: SvgPicture.asset(
                                        _tabController.index == 0
                                            ? 'assets/icons/list_video_selected.svg'
                                            : 'assets/icons/list_video.svg',
                                        width: 25,
                                      ),
                                    ),
                                    Tab(
                                      icon: SvgPicture.asset(
                                        _tabController.index == 1
                                            ? 'assets/icons/list_post_selected.svg'
                                            : 'assets/icons/list_post.svg',
                                        width: 25,
                                      ),
                                    ),
                                    Visibility(
                                      visible: !_isVisited,
                                      child: Tab(
                                        icon: SvgPicture.asset(
                                          _tabController.index == 2
                                              ? 'assets/icons/list_save_selected.svg'
                                              : 'assets/icons/list_save.svg',
                                          width: 17,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !_isVisited,
                                      child: Tab(
                                        icon: SvgPicture.asset(
                                          _tabController.index == 3
                                              ? 'assets/icons/list_like_selected.svg'
                                              : 'assets/icons/list_like.svg',
                                          width: 23,
                                        ),
                                      ),
                                    )
                                  ],
                                  indicatorColor: Colors.blue,
                                  onTap: (index) {
                                    _tabController.animateTo(index);
                                  },
                                ),
                              ))
                          : SliverPersistentHeader(
                              pinned: true,
                              floating: false,
                              delegate: _SliverAppBarDelegate(
                                TabBar(
                                  controller: _tabController,
                                  tabs: [
                                    Tab(
                                      icon: SvgPicture.asset(
                                        _tabController.index == 0
                                            ? 'assets/icons/list_video_selected.svg'
                                            : 'assets/icons/list_video.svg',
                                        width: 25,
                                      ),
                                    ),
                                    Tab(
                                      icon: SvgPicture.asset(
                                        _tabController.index == 1
                                            ? 'assets/icons/list_post_selected.svg'
                                            : 'assets/icons/list_post.svg',
                                        width: 25,
                                      ),
                                    ),
                                  ],
                                  indicatorColor: Colors.blue,
                                  onTap: (index) {
                                    _tabController.animateTo(index);
                                  },
                                ),
                              ))
                    ];
                  },
                  body: !_isVisited
                      ? TabBarView(
                          controller: _tabController,
                          children:[
                            const VideoTab(),
                            Expanded(child: PostTab(visitedUserID: widget.visitedUserID)),
                            const SaveTab(),
                            const LikeTab(),
                          ],
                        )
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            VideoTab(),
                            PostTab(visitedUserID: widget.visitedUserID),
                          ],
                        )),
            );
          }),
    );
  }

  final currentUser = FirebaseAuth.instance.currentUser!;

  Container buildButton(
      {required String text, required VoidCallback function}) {
    return Container(
      child: ElevatedButton(
        onPressed: function,
        style: ButtonStyle(
          side: MaterialStateProperty.all(
              const BorderSide(width: 1, color: Colors.blue)),
          minimumSize: MaterialStateProperty.all<Size>(
            const Size(150, 55),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
              _isFollowing ? Colors.white : Colors.blue),
          foregroundColor: MaterialStateProperty.all<Color>(
              _isFollowing ? Colors.blue : Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  buildProfileButton() {
    if (_isFollowing) {
      return buildButton(text: "Unfollow", function: handleUnfollowUser);
    } else {
      return buildButton(text: "Follow", function: handleFollowUser);
    }
  }

  handleUnfollowUser() async {
    setState(() {
      _isFollowing = false;
      _followersCount -= 1;
    });

    followersRef
        .doc(widget.visitedUserID)
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
        .doc(widget.visitedUserID)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

    userRef.update({
      'followingsList': FieldValue.arrayRemove([widget.visitedUserID])
    });
  }

  handleFollowUser() {
    followersRef
        .doc(widget.visitedUserID)
        .collection('userFollowers')
        .doc(widget.currentUserId)
        .set({});

    followingsRef
        .doc(widget.currentUserId)
        .collection('userFollowings')
        .doc(widget.visitedUserID)
        .set({});
    setState(() {
      _isFollowing = true;
      _followersCount += 1;
    });

    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    userRef.update({
      'followingsList': FieldValue.arrayUnion([widget.visitedUserID])
    });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
