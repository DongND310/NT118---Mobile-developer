import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String creatorId;
  final String creatorName;
  final String creatorImg;
  final String content;
  final Timestamp timestamp;

  PostModel({
    required this.postId,
    required this.creatorId,
    required this.creatorName,
    required this.creatorImg,
    required this.content,
    required this.timestamp,
  });

  // Chuyển đổi từ Firestore document thành PostModel
  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PostModel(
      postId: doc.id,
      creatorId: data['creatorId'] ?? '',
      creatorName: data['creatorName'] ?? '',
      creatorImg: data['creatorImg'] ?? '',
      content: data['content'] ?? '',
      timestamp: data['timestamp'] ?? 0,
    );
  }

  // Chuyển đổi từ PostModel thành Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'creatorImg': creatorImg,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
