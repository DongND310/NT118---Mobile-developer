import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_project/models/video.dart';
import 'package:video_player/video_player.dart';

class VideoTileIsFollowed extends StatefulWidget {
  const VideoTileIsFollowed(
      {super.key,
      required this.video,
      required this.snappedPageIndex,
      required this.currentIndex});
  final Video video;
  final int snappedPageIndex;
  final int currentIndex;
  @override
  State<VideoTileIsFollowed> createState() => _VideoTileIsFollowedState();
}

class _VideoTileIsFollowedState extends State<VideoTileIsFollowed> {
  late VideoPlayerController _videoPlayerController;
  late Future _initializeVideoPlayer;
  bool _isVideoPlaying = true;

  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.asset('assets/${widget.video.videoUrl}');
    _initializeVideoPlayer = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _pausePlayVideo() {
    _isVideoPlaying
        ? _videoPlayerController.pause()
        : _videoPlayerController.play();
    setState(() {
      _isVideoPlaying = !_isVideoPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    (widget.snappedPageIndex == widget.currentIndex && _isVideoPlaying)
        ? _videoPlayerController.play()
        : _videoPlayerController.pause();
    return Container(
      color: const Color(0xFF000141),
      child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: () => {_pausePlayVideo()},
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_videoPlayerController),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.play_arrow,
                        color:
                            Colors.white.withOpacity(_isVideoPlaying ? 0 : 0.5),
                        size: 60),
                  )
                ],
              ),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: Lottie.asset('assets/videos/loading.json',
                  width: 100, height: 100, fit: BoxFit.cover),
            );
          }
        },
        future: _initializeVideoPlayer,
      ),
    );
  }
}
