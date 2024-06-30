import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mobile_project/components/navigation_container.dart';
import 'package:mobile_project/screen/posts_videos/upload_video_controller.dart';
import 'package:mobile_project/services/video_service.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const ConfirmScreen(
      {super.key, required this.videoFile, required this.videoPath});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  VideoPlayerController? controller;
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController _captionController = TextEditingController();
  bool _showClearButton = false;
  final VideoService _videoService = VideoService();
  String content = '';
  String? _downloadURL;

  void _updateClearButtonVisibility(String value) {
    setState(() {
      _showClearButton = value.isNotEmpty;
    });
  }

  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller!.initialize().then((_) {
      setState(() {});
      controller!.play();
      controller!.setVolume(1);
      controller!.setLooping(true);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.black,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/ep_back.svg',
            width: 30,
            height: 30,
          ),
        ),
        title: const Text(
          'Đăng video',
          style: TextStyle(
            fontSize: 20,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              if (controller != null && controller!.value.isInitialized)
                Container(
                  color: Colors.amber,
                  width: MediaQuery.of(context).size.width - 20,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: AspectRatio(
                    aspectRatio: controller!.value.aspectRatio,
                    child: VideoPlayer(controller!),
                  ),
                )
              else
                const Center(child: CircularProgressIndicator()),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Mô tả",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        if (_showClearButton)
                          Container(
                            width: 40,
                            height: 25,
                            child: IconButton(
                              icon: Icon(Icons.clear),
                              iconSize: 18,
                              onPressed: () {
                                _captionController.clear();
                                _updateClearButtonVisibility('');
                              },
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      autofocus: true,
                      maxLines: 10,
                      minLines: 1,
                      cursorColor: Colors.blue,
                      controller: _captionController,
                      decoration: InputDecoration(
                        hintText: "Thêm mô tả cho video",
                        hintStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black12),
                            borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          content = value;
                        });
                        _updateClearButtonVisibility(value);
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: _uploadVideo,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "Đăng tải",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _uploadVideo() async {
    try {
      _downloadURL = await _videoService.uploadVideoToStorage(widget.videoPath);
      await _videoService.createVideoPost(
          '', user.uid, content, _downloadURL!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationContainer(
            currentUserID: user.uid,
            pageIndex: 0,
          ),
        ),
      );
    } catch (e) {
      // Xử lý lỗi nếu không upload được video
      print("Lỗi upload video: $e");
    }
  }
}
