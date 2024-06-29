import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mobile_project/models/video_model.dart';

class VideoController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var videos = <VideoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  void fetchVideos() {
    _firestore.collection('videos').snapshots().listen((snapshot) {
      videos.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return VideoModel(
          videoId: doc.id,
          postedById: data['postedById'] ?? '',
          caption: data['caption'] ?? '',
          videoUrl: data['videoUrl'] ?? '',
          timestamp: data['timestamp'] ?? Timestamp.now(),
          ref: doc.reference,
        );
      }).toList();
    });
  }
}
