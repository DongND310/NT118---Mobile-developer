import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/constants.dart';
import 'package:mobile_project/models/user_model.dart';
import 'package:mobile_project/screen/Follow/follower_listview.dart';
import 'package:mobile_project/services/database_services.dart';
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
  final user = FirebaseAuth.instance.currentUser!;

  int _followersCount = 0;
  int _followingCount = 0;

  getFollowersCount() async {
    int followersCount =
        await DatabaseServices.followersNum(widget.visitedUserID);
    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }

  getFollowingCount() async {
    int followingCount =
        await DatabaseServices.followingNum(widget.visitedUserID);
    if (mounted) {
      setState(() {
        _followingCount = followingCount;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
    getFollowersCount();
    getFollowingCount();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: usersRef.doc(widget.visitedUserID).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              );
            }
            UserModel userModel = UserModel.fromDoc(snapshot.data);
            return DefaultTabController(
              length: 4,
              child: NestedScrollView(
                headerSliverBuilder: (context, index) {
                  return [
                    SliverAppBar(
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
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileSettingPage(),
                              ),
                            );
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/setting_list.svg',
                            width: 18,
                          ),
                        ),
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
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: userModel.avt != null
                                    ? NetworkImage(userModel.avt!)
                                    : Image.asset(
                                            'assets/images/default_avt.png')
                                        .image,
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                userModel.name,
                                style: TextStyle(
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
                                                  ListFollowerScreen(), // update following
                                            ),
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '$_followingCount',
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(
                                              'Đang theo dõi',
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
                                                  ListFollowerScreen(),
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
                                              'Người theo dõi',
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
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChangeProfilePage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 55,
                                  width: 260,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.blue),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
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
                                    color: const Color.fromARGB(193, 0, 0, 0),
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
                    SliverPersistentHeader(
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
                              Tab(
                                icon: SvgPicture.asset(
                                  _tabController.index == 2
                                      ? 'assets/icons/list_save_selected.svg'
                                      : 'assets/icons/list_save.svg',
                                  width: 17,
                                ),
                              ),
                              Tab(
                                icon: SvgPicture.asset(
                                  _tabController.index == 3
                                      ? 'assets/icons/list_like_selected.svg'
                                      : 'assets/icons/list_like.svg',
                                  width: 23,
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
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    VideoTab(),
                    Expanded(child: PostTab()),
                    SaveTab(),
                    LikeTab(),
                  ],
                ),
              ),
            );
          }),
    );
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
