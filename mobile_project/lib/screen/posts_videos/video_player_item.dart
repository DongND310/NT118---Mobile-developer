import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerItem({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoPlayerController;
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    print("Video URL: ${widget.videoUrl}");
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
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
      return const Center(child: CircularProgressIndicator());
    } else if (_isError) {
      return const Center(child: Text("Lỗi tải video"));
    } else {
      return AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: VideoPlayer(_videoPlayerController),
      );
    }
  }
}
