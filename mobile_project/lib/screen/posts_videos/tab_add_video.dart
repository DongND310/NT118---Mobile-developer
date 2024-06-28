import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_project/screen/posts_videos/confirm_screen.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:mobile_project/components/navigation_container.dart';

class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({super.key});

  @override
  _AddVideoScreenState createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  final user = FirebaseAuth.instance.currentUser;

  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late int selectedCameraIndex;
  late String videoPath;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  Future<void> _initCameras() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        selectedCameraIndex = 0;
      });
      _initCameraController(cameras[selectedCameraIndex]);
    } else {
      print("No cameras found");
    }
  }

  Future<void> _initCameraController(
      CameraDescription cameraDescription) async {
    cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  //Pick video from the gallery
  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  // Display camera preview
  Widget _cameraPreviewWidget() {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: CameraPreview(cameraController),
      ),
    );

    // AspectRatio(
    //   aspectRatio: 16 / 9,
    //   // aspectRatio: cameraController.value.aspectRatio,
    //   child: CameraPreview(cameraController),
    // );
  }

  // Display the control bar with buttons to record video
  Widget _cameraControlWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: Icon(Icons.radio_button_on, color: Colors.white, size: 70),
              onPressed: () {
                _onCapturePressed(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Display a row of toggle to select the camera
  Widget _cameraToggleRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;
    return Expanded(
        child: Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: _onSwitchCamera,
        icon: Icon(
          _getCameraLensIcon(lensDirection),
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          '${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1).toUpperCase()}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ));
  }

  Widget _uploadFolder() {
    return Expanded(
        child: Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () => pickVideo(ImageSource.gallery, context),
        icon: const Icon(
          Icons.photo_library,
          color: Colors.white,
          size: 24,
        ),
        label: const Text(
          'Thư viện',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         NavigationContainer(currentUserID: user!.uid),
              //   ),
              // );
            },
            icon: SvgPicture.asset(
              'assets/icons/ep_back.svg',
              width: 30,
              height: 30,
            ),
          ),
          title: const Text(
            'Thêm video',
            style: TextStyle(
                fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: _cameraPreviewWidget(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black.withOpacity(1),
                    height: 90,
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _cameraToggleRowWidget(),
                        _cameraControlWidget(context),
                        _uploadFolder(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error:${e.code}\n Error message: ${e.description}';
    print(errorText);
  }

  void _onCapturePressed(context) async {
    if (cameraController.value.isRecordingVideo) {
      XFile video = await cameraController.stopVideoRecording();
      print('Video recorded to: ${video.path}');
    } else {
      final path = join((await getApplicationDocumentsDirectory()).path,
          '${DateTime.now()}.mp4');
      await cameraController.startVideoRecording();
      print('Recording video to: $path');
    }
    setState(() {});
  }

  void _onSwitchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    _initCameraController(selectedCamera);
  }

  IconData _getCameraLensIcon(CameraLensDirection lensDirection) {
    switch (lensDirection) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return CupertinoIcons.video_camera;
      default:
        return Icons.device_unknown;
    }
  }
}
