import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/models/user_model.dart';
import 'package:mobile_project/screen/Search/search.dart';
import 'package:mobile_project/screen/homepage/homepage_post.dart';
import 'package:mobile_project/screen/homepage/homepage_video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.currentUserId}) : super(key: key);
  final String currentUserId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isVideoPage = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _tabController.addListener(_handleTabSelection);
    _selectedIndex = 1;
  }

  void _handleTabSelection() {
    setState(() {
      _selectedIndex = _tabController.index;
      _isVideoPage = _tabController.index == 1;
    });
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
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.currentUserId)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            );
          }
          UserModel userModel = UserModel.fromDoc(snapshot.data!);
          return DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (context, index) {
                return [
                  SliverPersistentHeader(
                    pinned: true,
                    floating: false,
                    delegate: _SliverAppBarDelegate(
                      AppBar(
                        toolbarHeight: 80,
                        elevation: 0,
                        backgroundColor: Colors.blue,
                        centerTitle: true,
                        leading: IconButton(
                          icon: const Icon(Icons.search),
                          color: const Color(0xffF1FCFD),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchScreen(),
                              ),
                            );
                          },
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isVideoPage = false;
                                  _tabController.animateTo(0);
                                });
                              },
                              child: Text(
                                "Bài viết",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: !_isVideoPage
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: !_isVideoPage
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isVideoPage = true;
                                  _tabController.animateTo(1);
                                });
                              },
                              child: Text(
                                "Video",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: _isVideoPage
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color:
                                      _isVideoPage ? Colors.white : Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(width: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  HPPostTab(
                    currentId: widget.currentUserId,
                  ),
                  HPVideoTab(
                    currentUserId: widget.currentUserId,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final AppBar _appBar;

  _SliverAppBarDelegate(this._appBar);

  @override
  double get minExtent => _appBar.preferredSize.height;

  @override
  double get maxExtent => _appBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return _appBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
