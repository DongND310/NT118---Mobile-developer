import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/screen/Follow/follower_listview.dart';
import 'proflie_setting.dart';
import 'tab_like.dart';
import 'tab_post.dart';
import 'tab_save.dart';
import 'tab_video.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;
  String? _name;
  String? _id;
  String? _email;
  String? _dob;
  String? _phone;
  String? _gender;
  String? _nation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
    getUserData();

    print(user.email);
    print(user.uid);
  }

  void getUserData() async {
    User currentUser = _auth.currentUser!;
    _uid = currentUser.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    _id = userDoc.get('ID');
    _name = userDoc.get('Name');
    _email = userDoc.get('Email');
    _dob = userDoc.get('DOB');
    _phone = userDoc.get('Phone');
    _gender = userDoc.get('Gender');
    _nation = userDoc.get('Nation');
    // _name = userDoc.get('Name');
    print(_id);
    print(_name);
    setState(() {});
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
                _id ?? '',
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const SizedBox(
                          width: 100,
                          height: 100,
                          // child: Image.asset(''),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _name ?? '',
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '500K',
                                      style: TextStyle(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '1.5M',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
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
                              builder: (context) => ProfileSettingPage(),
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
                        child: const Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eleifend orci et enim imperdiet, vestibulum hendrerit mi condimentum.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
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
            PostTab(),
            SaveTab(),
            LikeTab(),
          ],
        ),
      ),
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
