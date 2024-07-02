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
        userRef.update({'push_token': t});
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
    const serviceAccountJson = {
      "type": "service_account",
      "project_id": "nt118-reelreplay",
      "private_key_id": "453d61965448b121c3888d4c5f69f457091b64c2",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC7LXnf5TyAJ/3A\ndF+A2UFSFD+JC3QVNBTea6H3LftMvCjNFsV/J+6Zcj4HSUfEmR1hlSkz0+3Yp2ty\nH0Pzl17YyQ19MFaCaoV0o+Y/khSu/6mbRQSGDdQ3yTlaoRWq/+Qt+C1EY56WssRE\nzxexuwU47TWvo0I7jYqAYSURVmTW3Urh5whEQIjkplZYkzPx3210jf2X+M06/Exg\nujKo2eETcnvQ7cm7IyY+4/HkrKN3X0fyEUDq9bT7uNDXOz7GMQUV6+Jpty/QC/8r\nPzThF4QOP66JovlCajiWtyh8AKxMLL7Hc8JMcYTipDH7csoyQQc5GEbCcWhCKBfk\nIHl5XjCDAgMBAAECggEAAqaCM0lrseTfEvqS36Az7JWc0LP40NQL95pOkNF13YBM\nk5re8Q3/suyLNE81VPNWFyulibZWh9rXCqamr6xVC3zNVBh7IR2hBiXL/Np0sIWu\nQSSZC8zmVGPlDAN76w/0izIYcf93H2sonFDSZRHg4Q161SHarj0y2N6HR9eRVfmF\n9Bz+ykiWY5gUfe1PQfZQw9Q70YJjtuXFMhCgUbDslNJiJscVs9zrmUCElBF6j2L9\nOFBUynzsnKM5araUquNetjzfv/f19CEaoTDsKLbbOT3vCPrYDcho++it7NkBNo/3\n6Jn44IW3Hkncb+fwWkROnM9yur4uls9T9VflDVSUAQKBgQD64w+6mbL3HHjkw7h5\n7K8LDIsvp7pKNm5KtddPbQUmwwR3Ol0JrJ5TDA2jayO5aXdYPEseSPTKpIsn+4lr\nhlAuzhEjiFGIcU6IySOf/vOSGQqoalfGPcf1rxPpmZt+REHK+IBrSD3Ys2dd+s8w\nziXnzUJucPTDMfzC7MjlRQfPUwKBgQC+/gcN3Xu6jzh0VpB4A6bN89+XY39HE5fp\nb+akzSSnEuwYIUJF3T5aUs4T1I202Z3WheXUnR3adh6/fwFxvak5JcMGX0UfnwAC\n/dFHMMHBYQaaSLTYXMgeZy3GL+6K1wpFTm6ErFB2HU/wNGW8F8k5mIIcIK8JNA3g\n6z6kaw9kEQKBgFlPr2+7+0ugpSC609cDfKSwSHQkf1qf2c9awFUT+Dt+PP68lhY1\njv79UXWVVFhSxRtyC0OysQHaZXdMQfU3ESA4Vz2Q74Vk4JItGDOCrO6bX4HoqWp2\n39IEC1CjUAk4/zrkD8MhKnMUGn4IJO241SGZnkZ2i4tZJiO16yZC1q7lAoGAD/8U\ntiuTvldaghvx86tSoDNJydMyiNByS8HsjmcEJ94k2gyHEXTrUQNYcT6/M6N6XcpP\nKpSSOIbmImHPzCf3cWrhP7pg/roBdT6u9Yh24exvciKeyvRSaoF3yv6euxAxswZT\nqVcJUis4U8T/tFZFq0ZDt3lhT6MFeo4ZbAnvexECgYAmBMl8IySAmgq2tnEw9/Yk\nL3UIeoyihT30p2S3trH+CemO70irS3cN4c1URtaWB7N0n4Hx0lLWWK0Vp+cbyjZr\nEd+9QF2pHq5c2jsodx/yS7uC4pmnpPwoV8ratVgKOSjXNB2M/n+Xbal5SjSV21WW\nrs6G8FHxlInPIJh2WFgGNQ==\n-----END PRIVATE KEY-----\n",
      "client_email": "nt118-reelreplay@appspot.gserviceaccount.com",
      "client_id": "106927105445400567381",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/nt118-reelreplay%40appspot.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);
    //get the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);
    client.close();
    return credentials.accessToken.data;
  }

  Future<void> sendPushNotification(String userId, String msg) async{
    try{
      DocumentSnapshot userReceiver = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      DocumentSnapshot userSend = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final String serverAccessTokenKey = await getAccessToken();
      String endpointFirebaseCloudMessaging =
          'https://fcm.googleapis.com/v1/projects/nt118-reelreplay/messages:send';

      final Map<String, dynamic> message = {
        'message': {
          'token': userReceiver.get('push_token'),
          'notification': {
            'title': user.displayName ?? 'Notification',
            'body': msg
          },
          'android': {
            'notification': {
              'channel_id': 'chats',
              'sound': 'default'
            }
          },
          'data': {
            'type': 'chat',
            'receiverId': user.uid,
            'receiverName': user.displayName,
            'chatterImg': userReceiver.get('Avt')
          }
        }
      };
      log(jsonEncode(message));
      final http.Response response = await http.post(Uri.parse(endpointFirebaseCloudMessaging),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $serverAccessTokenKey'
          },
          body: jsonEncode(message)
      );
      log("response status: ${response.statusCode}");
      log('body: ${response.body}');
    } catch (e) {
      log('sendNotificationE: $e');
    }
  }
}
