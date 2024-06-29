import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    print("link video: ${widget.videoUrl}");
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            aspectRatio: _videoPlayerController.value.aspectRatio,
            autoPlay: true,
            looping: true,
          );
        });
      }).catchError((error) {
        print("Error initializing video player: $error");
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? Chewie(controller: _chewieController!)
        : const Center(child: CircularProgressIndicator(color: Colors.blue));
  }
}
