import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_project/models/video_model.dart';
import 'package:video_compress/video_compress.dart';

// class UploadVideoController extends GetxController {
//   final user = FirebaseAuth.instance.currentUser!;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   _compressVideo(String videoPath) async {
//     final compressedVideo = await VideoCompress.compressVideo(
//       videoPath,
//       quality: VideoQuality.MediumQuality,
//     );
//     return compressedVideo!.file;
//   }

//   Future<String> _uploadVideoToStorage(String id, String videoPath) async {
//     Reference ref = FirebaseStorage.instance.ref().child('videos').child(id);
//     UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
//     TaskSnapshot snap = await uploadTask;
//     String downloadUrl = await snap.ref.getDownloadURL();
//     return downloadUrl;
//   }

//   _getThumbnail(String videoPath) async {
//     final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
//     return thumbnail;
//   }

//   Future<String> _uploadImageToStorage(String id, String videoPath) async {
//     Reference ref =
//         FirebaseStorage.instance.ref().child('thumbnails').child(id);
//     UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
//     TaskSnapshot snap = await uploadTask;
//     String downloadUrl = await snap.ref.getDownloadURL();
//     return downloadUrl;
//   }

//   uploadVideo(String songName, String caption, String videoPath) async {
//     try {
//       String _uid = _auth.currentUser!.uid;
//       final DocumentSnapshot userDoc =
//           await FirebaseFirestore.instance.collection('users').doc(_uid).get();
//       var allDocs = await FirebaseFirestore.instance.collection('videos').get();
//       int len = allDocs.docs.length;
//       String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
//       String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

//       VideoModel videoModel = VideoModel(
//           videoId: "Video $len",
//           postedById: userDoc.get('ID'),
//           caption: caption,
//           videoUrl: videoUrl,
//           timestamp: Timestamp.now()
//           // postByName: userDoc.get('Name'),
//           // postByAvt: userDoc.get('Avt'),
//           // songName: songName,
//           // thumbnail: thumbnail,
//           // likes: [],
//           // comments: 0,
//           // bookmarks: 0,
//           );

//       await FirebaseFirestore.instance
//           .collection('videos')
//           .doc('Video $len')
//           .set(videoModel.toJson());
//       Get.back();
//     } catch (e) {
//       Get.snackbar(
//         'Error Uploading Video',
//         e.toString(),
//       );
//     }
//   }
// }
import 'package:get/get.dart';
import 'package:mobile_project/services/video_service.dart';

class UploadVideoController extends GetxController {
  final VideoService _videoService = VideoService();

  Future<void> uploadVideo(String videoPath) async {
    try {
      String downloadURL = await _videoService.uploadVideoToStorage(videoPath);
      await _videoService.saveVideoData(downloadURL);
    } catch (e) {
      print("Upload video thất bại: $e");
    }
  }
}
