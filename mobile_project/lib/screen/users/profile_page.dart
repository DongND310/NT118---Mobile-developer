import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_project/_mock_data/mock.dart';
import 'package:mobile_project/components/button.dart';
import 'package:mobile_project/components/navigation_container.dart';
import 'package:mobile_project/constants.dart';
import 'package:mobile_project/models/user_model.dart';
import 'package:mobile_project/screen/Follow/follower_listview.dart';
import 'package:mobile_project/services/database_services.dart';
import 'package:mobile_project/services/folow_service.dart';
import 'package:mobile_project/util/imagepicker.dart';
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
      // {super.key,
      // required this.currentUserId});
  final String currentUserId;
  final String visitedUserID;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final user = FirebaseAuth.instance.currentUser!;
  bool _isPressed = false;
  late bool _isVisited;
  bool _isFollowing = false;
  int _followersCount = 0;
  int _followingCount = 0;
  final FollowService _followService = FollowService();
  getFollowersCount() async {
    int followersCount =
        await DatabaseServices.followersNum(widget.visitedUserID);
       // await DatabaseServices.followersNum(widget.currentUserId);
    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }

  getFollowingCount() async {
    int followingCount =
         await DatabaseServices.followingNum(widget.visitedUserID);
        //await DatabaseServices.followingNum(widget.currentUserId);
    if (mounted) {
      setState(() {
        _followingCount = followingCount;
      });
    }
  }
  checkFollowing()async{
    bool isFollowing = await DatabaseServices.isFollowing(widget.visitedUserID, widget.currentUserId);
    setState(() {
      _isFollowing = isFollowing;
    });
  }
  @override
  void initState() {
    super.initState();
    if(widget.currentUserId != widget.visitedUserID)
      {
        _isVisited = true;
      }
    _tabController = TabController(length: !_isVisited?4:2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    checkFollowing();
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

  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          // future: usersRef.doc(widget.visitedUserID).get(),
          future: usersRef.doc(widget.currentUserId).get(),
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
              length: !_isVisited?4:2,
              child: NestedScrollView(
                headerSliverBuilder: (context, index) {
                  return [
                    SliverAppBar(
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
                                builder: (context) => ProfileSettingPage(),
                              ),
                            );
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/setting_list.svg',
                            width: 18,
                          ),
                        ))
                        ,
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
                              !_isVisited?
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
                                  height: 45,
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
                              )
                              :Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     if(_isPressed == true){
                                  //       follow();
                                  //     }
                                  //     else
                                  //       {
                                  //         _followService.Unfollow(widget.currentUserId, widget.visitedUserID);
                                  //       }
                                  //     setState(() {
                                  //       _isPressed = !_isPressed;
                                  //     });
                                  //   },
                                  //   style: ButtonStyle(
                                  //     side: MaterialStateProperty.all(
                                  //         BorderSide(
                                  //             width: 1, color: Colors.blue)),
                                  //     minimumSize:
                                  //     MaterialStateProperty.all<Size>(
                                  //       Size(130, 55),
                                  //     ),
                                  //     backgroundColor:
                                  //     MaterialStateProperty.all<Color>(
                                  //         !_isPressed
                                  //             ? Colors.blue
                                  //             : Colors.white),
                                  //     foregroundColor:
                                  //     MaterialStateProperty.all<Color>(
                                  //         !_isPressed
                                  //             ? Colors.white
                                  //             : Colors.blue),
                                  //     shape: MaterialStateProperty.all<
                                  //         RoundedRectangleBorder>(
                                  //       RoundedRectangleBorder(
                                  //         borderRadius:
                                  //         BorderRadius.circular(10),
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   child: Center(
                                  //     child: Text(
                                  //       !_isPressed
                                  //           ? 'Theo dõi'
                                  //           : 'Hủy theo dõi',
                                  //       style: TextStyle(
                                  //         fontSize: 20,
                                  //         fontWeight: FontWeight.w600,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
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
                    !_isVisited?
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
                              ),)
                            ],
                            indicatorColor: Colors.blue,
                            onTap: (index) {
                              _tabController.animateTo(index);
                            },
                          ),
                        )):
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
                            ],
                            indicatorColor: Colors.blue,
                            onTap: (index) {
                              _tabController.animateTo(index);
                            },
                          ),
                        ))
                  ];
                },
                body:!_isVisited? TabBarView(
                  controller: _tabController,
                  children: const [
                    VideoTab(),
                    Expanded(child: PostTab()),
                    SaveTab(),
                    LikeTab(),
                  ],
                )
                    :TabBarView(
                  controller: _tabController,
                  children: const [
                    VideoTab(),
                    PostTab(),
                  ],
                )
              ),
            );
          }),
    );
  }
  Container buildButton({required String text, required VoidCallback function})
  {
    return Container(
      child: ElevatedButton(
        onPressed: function,
        style: ButtonStyle(
          side: MaterialStateProperty.all(
              const BorderSide(
                  width: 1, color: Colors.blue)),
          minimumSize:
          MaterialStateProperty.all<Size>(
            const Size(150, 55),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
              _isFollowing ? Colors.white : Colors.blue),
          foregroundColor: MaterialStateProperty.all<Color>(
              _isFollowing ? Colors.blue : Colors.white),
          shape: MaterialStateProperty.all<
              RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(10),
            ),
          ),
        ),
        child: Center(
          child: Text( text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

    );
  }
  buildProfileButton()
  {
    if(_isFollowing)
      {
        return buildButton(text: "Unfollow", function: handleUnfollowUser);
      }
    else
      {
        return buildButton(text: "Follow", function: handleFollowUser);
      }
  }
  handleUnfollowUser()
  async {
    setState(() {
      _isFollowing= false;
      _followersCount -=1;
    });
    QuerySnapshot querySnapshot = await followsRef
        .where("followed_user_id", isEqualTo: widget.visitedUserID)
        .where("following_user_id", isEqualTo: widget.currentUserId)
        .get();
    for(QueryDocumentSnapshot doc in querySnapshot.docs)
      {
        await followsRef.doc(doc.id).delete();
      }
  }
  handleFollowUser()
  {
    followsRef
      .doc(widget.visitedUserID)
      .set(
        {
          "followed_user_id": widget.visitedUserID, //người được follow
          "following_user_id": widget.currentUserId
        });
    setState(() {
      _isFollowing= true;
      _followersCount +=1;
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
