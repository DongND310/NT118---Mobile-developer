import 'package:flutter/material.dart';
import 'package:mobile_project/components/home_side_bar.dart';
import 'package:mobile_project/components/videocreatorinfo.dart';
import 'package:mobile_project/models/video.dart';
import 'package:mobile_project/models/video_model.dart';
import 'package:mobile_project/screen/posts_videos/video_player_item.dart'; // Đảm bảo import model video hoặc sử dụng như mong đợi

class VideoDetailScreen extends StatelessWidget {
  final VideoModel video;

  VideoDetailScreen({required this.video});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
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
        ));
  }
}
