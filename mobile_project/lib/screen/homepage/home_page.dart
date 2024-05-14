import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/_mock_data/mock.dart';
import 'package:mobile_project/_mock_data/mock_copy.dart';
import 'package:mobile_project/components/home_side_bar.dart';
import 'package:mobile_project/components/video_detail.dart';
import 'package:mobile_project/components/video_tile.dart';
import 'package:mobile_project/components/video_tile_followed.dart';
import 'package:mobile_project/screen/Search/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.currentUserId});
  final String currentUserId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFollowingSelected = false;
  final user = FirebaseAuth.instance.currentUser;
  int _snappedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.search),
            color: const Color(0xffF1FCFD),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isFollowingSelected = true;
                  });
                },
                child: Text(
                  "Đang theo dõi",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 15,
                      fontWeight: _isFollowingSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: _isFollowingSelected
                          ? const Color(0xffF1FCFD)
                          : Colors.grey),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () => {
                  setState(() {
                    _isFollowingSelected = false;
                  })
                },
                child: Text(
                  "Dành cho bạn",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 15,
                      fontWeight: _isFollowingSelected
                          ? FontWeight.normal
                          : FontWeight.w600,
                      color: !_isFollowingSelected
                          ? const Color(0xffF1FCFD)
                          : Colors.grey),
                ),
              ),
              const SizedBox(width: 50),
            ],
          ),
        ),
        body: PageView.builder(
            onPageChanged: (int page) {
              setState(() {
                _snappedPageIndex = page;
              });
            },
            scrollDirection: Axis.vertical,
            itemCount: _isFollowingSelected ? videos.length : copyvideos.length,
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  _isFollowingSelected
                      ? VideoTileIsFollowed(
                          video: copyvideos[index],
                          snappedPageIndex: _snappedPageIndex,
                          currentIndex: index,
                        )
                      : VideoTile(
                          video: videos[index],
                          snappedPageIndex: _snappedPageIndex,
                          currentIndex: index,
                        ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 6,
                        child: VideoDetail(
                          video: _isFollowingSelected
                              ? videos[index]
                              : copyvideos[index],
                          user: _isFollowingSelected
                              ? users[index]
                              : copyusers[index],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          height: MediaQuery.of(context).size.height / 3,
                          child: HomeSideBar(
                            video: _isFollowingSelected
                                ? videos[index]
                                : copyvideos[index],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            }));
  }
}
