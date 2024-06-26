
import 'package:mobile_project/models/user.dart';
import 'package:mobile_project/models/video.dart';

User demoUser4 = User('user_4', 'https://picsum.photos/id/1/200/200');
User demoUser5 = User('user_5', 'https://picsum.photos/id/8/200/200');
User demoUser6 = User('user_6', 'https://picsum.photos/id/10/200/200');
User demoUser8 = User('user_7', 'https://picsum.photos/id/158/200/200');

final List<User> copyusers = [
  demoUser4,
  demoUser5,
  demoUser6,
  demoUser8,
];

List<Video> copyvideos = [
  Video('videos/v3.mp4', demoUser4, 'caption', 'hong on roi',
      '154', '22', '5'),
  Video('videos/v2.mp4', demoUser5, 'caption', 'audioName',
       '15M', '4852', '25'),
  Video('videos/v1.mp4', demoUser6, 'caption', 'audioName',
      '2.5K', '100', '1'),
  Video('videos/v4.mp4', demoUser8, 'caption', 'audioName',
      '15M', '1.5M', '0'),
];
