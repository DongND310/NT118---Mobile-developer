import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile_project/components/home_side_bar.dart';
import 'package:mobile_project/components/videocreatorinfo.dart';
import 'package:mobile_project/screen/posts_videos/video_controller.dart';
import 'package:mobile_project/screen/posts_videos/video_player_item.dart';

class HPVideoTab extends StatefulWidget {
  HPVideoTab({super.key, required this.currentUserId});

  final String currentUserId;
  final VideoController controller = Get.put(VideoController());

  @override
  State<HPVideoTab> createState() => _HPVideoTabState();
}

class _HPVideoTabState extends State<HPVideoTab> {
  final user = FirebaseAuth.instance.currentUser;
  int _snappedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (widget.controller.videos.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.blue,
          ));
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
                  VideoPlayerItem(videoUrl: video.videoUrl),
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
                            height: MediaQuery.of(context).size.height / 2.5,
                            child: HomeSideBar(
                              video: video,
                              likesList: [],
                              repliesList: [],
                              savesList: [],
                            ),
                          ))
                    ],
                  )
                ],
              );
            });
      }),
    );
  }
}
