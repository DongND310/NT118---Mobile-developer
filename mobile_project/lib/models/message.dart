import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String receiverImg;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderId,
      required this.senderName,
      required this.receiverId,
      required this.receiverName,
      required this.receiverImg,
      required this.message,
      required this.timestamp});
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverImg': receiverImg,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
