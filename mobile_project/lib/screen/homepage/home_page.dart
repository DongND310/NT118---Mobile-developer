import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_project/components/home_side_bar.dart';
import 'package:mobile_project/components/videocreatorinfo.dart';
import 'package:mobile_project/screen/Search/search.dart';
import 'package:mobile_project/screen/posts_videos/video_controller.dart';
import 'package:mobile_project/screen/posts_videos/video_player_item.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.currentUserId});
  final String currentUserId;
  final VideoController controller = Get.put(VideoController());

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
        backgroundColor: const Color.fromARGB(255, 99, 159, 208),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.search),
          color: const Color(0xffF1FCFD),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
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
                          : Colors.grey,
                    ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isFollowingSelected = false;
                });
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
                          : Colors.grey,
                    ),
              ),
            ),
            const SizedBox(width: 50),
          ],
        ),
      ),
      body: Obx(() {
        if (widget.controller.videos.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return PageView.builder(
          onPageChanged: (int page) {
            setState(() {
              _snappedPageIndex = page;
            });
          },
          scrollDirection: Axis.vertical,
          itemCount: widget.controller.videos.length,
          itemBuilder: (context, index) {
            final video = widget.controller.videos[index];
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                VideoPlayerItem(videoUrl: video.videoUrl, index: index),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 2,
                      child: VideoCreatorInfo(video: video),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: MediaQuery.of(context).size.height / 3,
                        child: HomeSideBar(
                          video: video,
                          likesList: [],
                          repliesList: [],
                          savesList: [],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
