import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/screen/Follow/follower_listview.dart';
import 'profile_header.dart';
import 'profile_appbar.dart';
import 'proflie_setting.dart';
import 'tab_like.dart';
import 'tab_post.dart';
import 'tab_save.dart';
import 'tab_video.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
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
            CustomProfileAppBar(),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: ProfileHeader(),
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
