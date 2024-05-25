import 'package:mobile_project/models/user.dart';
import 'package:mobile_project/models/video.dart';

User currentUser = User('demo', 'https://picsum.photos/id/1/200/200');
User demoUser1 = User('user_1', 'https://picsum.photos/id/8/200/200');
User demoUser2 = User('user_2', 'https://picsum.photos/id/10/200/200');
User demoUser3 = User('user_3', 'https://picsum.photos/id/158/200/200');

final List<User> users = [
  currentUser,
  demoUser1,
  demoUser2,
  demoUser3,
];

List<Video> videos = [
  Video(
    'videos/v1.mp4',
    demoUser1,
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec consectetur feugiat ex, at gravida tortor elementum eget. Nulla fermentum ultrices dolor in iaculis. Integer consequat quam eu dolor accumsan rutrum.',
    'audioName',
    'https://picsum.photos/id/1/200/200',
    '154',
    '22',
    '5',
  ),
  Video('videos/v2.mp4', demoUser2, 'caption', 'audioName',
      'https://picsum.photos/id/85/200/200', '15M', '4852', '25'),
  Video('videos/v3.mp4', demoUser3, 'caption', 'audioName',
      'https://picsum.photos/id/75/200/200', '2.5K', '100', '1'),
  Video('videos/v4.mp4', currentUser, 'caption', 'audioName',
      'https://picsum.photos/id/82/200/200', '15M', '1.5M', '0'),
];
