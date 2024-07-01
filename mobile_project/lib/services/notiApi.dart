import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class NotiApi {
  late User user;
  late DocumentReference userRef;
  late Future<void> _initializationFuture;

  NotiApi() {
    _initializationFuture = initialize();
  }

  Future<void> initialize() async {
    user = FirebaseAuth.instance.currentUser!;
    userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  }

  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;

  Future<void> getFirebaseMessagingToken() async {
    await _initializationFuture; // Ensure initialization is complete
    await fmessaging.requestPermission();
    fmessaging.getToken().then((t) {
      if (t != null) {
        userRef.update({
          'push_token': t
        });
        log('Push token: $t');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log('Got a message whilst in the foreground!');
        log('Message data: ${message.data}');
        if (message.notification != null) {
          log('Message also contained a notification: ${message.notification}');

        }
      });
  }
  static Future<String> getAccessToken() async {
    const serviceAccountJson =
  {
    "type": "service_account",
    "project_id": "nt118-reelreplay",
    "private_key_id": "453d61965448b121c3888d4c5f69f457091b64c2",
    "client_email": "nt118-reelreplay@appspot.gserviceaccount.com",
    "client_id": "106927105445400567381",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/nt118-reelreplay%40appspot.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes
    );
    //get the access token
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client
    );
    client.close();
    return credentials.accessToken.data;
  }

  Future<void> sendPushNotification(String userId, String msg) async{
    try{
      DocumentSnapshot userSend = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final String serverAccessTokenKey = await getAccessToken();
      String endpointFirebaseCloudMessaging = 'https://fcm.googleapis.com/v1/projects/nt118-reelreplay/messages:send';

      final Map<String, dynamic> message =
      {
        'message': {
          'token': userSend.get('push_token'),
          'notification': {
            'title': user.displayName ?? 'Notification', // Fallback title if displayName is null
            'body': msg
          },
          'android': {
            'notification': {
              'channel_id': 'chats',
              'sound': 'default'
            }
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          }
        }
      };
      final http.Response response = await http.post(Uri.parse(endpointFirebaseCloudMessaging),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $serverAccessTokenKey'
          },
          body: jsonEncode(message)
      );
      log("response status: ${response.statusCode}");
      log('body: ${response.body}');
    }catch(e)
    {
      log('sendNotificationE: $e');
    }
  }
}
