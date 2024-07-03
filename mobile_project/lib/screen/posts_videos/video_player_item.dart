import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_project/screen/posts_videos/videodemo.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  // final int index;

  VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    // required this.index,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoPlayerController;
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    print("Video URL: ${widget.videoUrl}");
    // print("Video index: ${widget.index}");
    // print("Video index: assets/videos/video_demo_${widget.index}.mp4");
    _initializePlayer();
    // print("videoFile index: $videoFile");
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      // _videoPlayerController =
          // VideoPlayerController.asset('video_demo_${widget.index}.mp4')
            ..addListener(() {
              if (mounted) {
                setState(() {});
              }
            })
            ..setLooping(true);
      await _videoPlayerController.initialize();
      _videoPlayerController.play();
      setState(() {
        _isLoading = false;
        _isError = false;
      });
    } catch (error) {
      print("Error initializing video player: $error");
      if (error is PlatformException) {
        print("PlatformException details: ${error.message}, ${error.details}");
      }
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      );
    } else if (_isError) {
      return Container(
        color: const Color.fromARGB(146, 63, 89, 91),
        child: const Center(
            child: CircularProgressIndicator(
          color: Colors.blue,
        )),
      );
    } else {
      return AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: VideoPlayer(_videoPlayerController),
      );
    }
  }
}
