import 'package:flutter/material.dart';
import 'package:mobile_project/_mock_data/mock.dart';
import 'package:mobile_project/components/home_side_bar.dart';
import 'package:mobile_project/components/video_detail.dart';
import 'package:mobile_project/components/video_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFollowingSelected = true;
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
          color: const Color(0xffF1FCFD), // Icon tìm kiếm
          onPressed: () {
            // Xử lý sự kiện khi nhấn vào nút tìm kiếm
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => {
                setState(() {
                  _isFollowingSelected = true;
                })
              },
              child: Text(
                "Đang theo dõi",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 10,
                    color: _isFollowingSelected
                        ? const Color(0xffF1FCFD)
                        : Colors.grey),
              ),
            ),
            const Text(" "),
            GestureDetector(
              onTap: () => {
                setState(() {
                  _isFollowingSelected = false;
                })
              },
              child: Text(
                "Dành cho bạn",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 10,
                    color: !_isFollowingSelected
                        ? const Color(0xffF1FCFD)
                        : Colors.grey),
              ),
            ),
            const Text("     "),
          ],
        ),
      ),
      body: PageView.builder(
          onPageChanged: (int page) => {
                setState(() {
                  _snappedPageIndex = page;
                }),
              },
          scrollDirection: Axis.vertical,
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                VideoTile(
                  video: videos[index],
                  snappedPageIndex: _snappedPageIndex,
                  currentIndex: index,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        child: VideoDetail(
                          video: videos[index],
                          user: users[index],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 2.5,
                        child: HomeSideBar(
                          video: videos[index],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }),
    );
  }
}
