import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_project/services/notiApi.dart';
import '../models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;
  String? _name;
  String? _avt;

  Future<void> getUserData() async {
    User currentUser = _auth.currentUser!;
    _uid = currentUser.uid;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    _name = userDoc.get('Name');
    _avt = userDoc.get('Avt');
  }

  // Send message
  Future<void> sendMessage(String receiverId, String receiverName, String message) async {
    final Timestamp timestamp = Timestamp.now();
    await getUserData();

    // Create message
    Message newMessage = Message(
      senderId: _auth.currentUser!.uid,
      senderName: _name ?? '',
      receiverId: receiverId,
      receiverName: receiverName,
      message: message,
      timestamp: timestamp,
    );

    // Chatroom ID
    List<String> ids = [_auth.currentUser!.uid, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    DocumentSnapshot chatRoomSnapshot = await _firestore.collection("chatrooms").doc(chatRoomId).get();
    if (!chatRoomSnapshot.exists) {
      // Create a new chatroom document
      _firestore.collection("chatrooms").doc(chatRoomId).set({
        "chatroomId": chatRoomId,
      });
    }

    // Add message to database
    await _firestore.collection("chatrooms").doc(chatRoomId).collection("messages").add(newMessage.toMap()).then((value) async {
      bool isNotificationEnabled = await getNotificationState(receiverId, _auth.currentUser!.uid);
      if (isNotificationEnabled) {
        NotiApi notiApi = NotiApi();
        notiApi.sendPushNotification(receiverId, message);
      }
    });
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userID, String anotherUserID) {
    List<String> ids = [userID, anotherUserID];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firestore.collection("chatrooms").doc(chatRoomId).collection("messages").orderBy("timestamp", descending: false).snapshots();
  }

  Stream<QuerySnapshot> getLastMessage(String chatRoomId) {
    return _firestore.collection("chatrooms").doc(chatRoomId).collection("messages").orderBy("timestamp", descending: true).limit(1).snapshots();
  }

  Future<void> setNotificationState(bool state, String currentUserId, String receiverId) async {
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    DocumentReference chatRoomDoc = _firestore.collection('chatrooms').doc(chatRoomId);
    await chatRoomDoc.set({
      'notificationSettings': {
        currentUserId: state,
      }
    }, SetOptions(merge: true));
  }

  Future<bool> getNotificationState(String currentUserId, String receiverId) async {
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    DocumentSnapshot doc = await _firestore.collection('chatrooms').doc(chatRoomId).get();
    if (doc.exists && doc.data() != null) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('notificationSettings')) {
        Map<String, dynamic> notificationSettings = data['notificationSettings'];
        return notificationSettings[currentUserId] ?? false;
      }
    }
    return false;
  }
}
