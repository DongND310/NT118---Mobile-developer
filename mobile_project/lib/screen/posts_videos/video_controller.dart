import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mobile_project/models/video_model.dart';
import 'package:mobile_project/services/video_service.dart';

class VideoController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // var videos = <VideoModel>[].obs;
  // RxList<Video> videos = <Video>[].obs;
  RxList<VideoModel> videos = <VideoModel>[].obs;
  final VideoService _videoService = VideoService();

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  void fetchVideos() async {
    try {
      List<VideoModel> fetchedVideos = await _videoService.getVideos();
      videos.assignAll(fetchedVideos);
    } catch (e) {
      print('Error fetching videos lỗi load video: $e');
    }
    _firestore.collection('videos').snapshots().listen((snapshot) {
      videos.value = snapshot.docs.map((doc) {
        final data = doc.data();
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
