import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/screen/users/proflie_setting.dart';

class AboutUsScreen extends StatelessWidget {
  AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileSettingPage(),
              ),
            );
          },
          icon: SvgPicture.asset(
            'assets/icons/ep_back.svg',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
        ),
        title: const Text(
            'Về chúng tôi',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
      ),
      //Nội dung hiển thị
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mục 1: Nội dung
              Text(
                'Mục đích:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Reels Replay là ứng dụng chia sẻ video ngắn, bài viết cho phép người dùng tạo, chia sẻ và xem nội dung một cách dễ dàng và thú vị. Ứng dụng cung cấp nhiều tính năng sáng tạo và độc đáo giúp người dùng thỏa sức thể hiện bản thân và kết nối với cộng đồng.',
              ),
              SizedBox(height: 16),

              // Mục 2: Mục tiêu và sứ mệnh
              Text(
                'Mục tiêu và sứ mệnh:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      '- Mục tiêu của Reels Replay là mang đến một nền tảng chia sẻ bài viết, video ngắn vui nhộn và giải trí cho người dùng.'),
                  Text(
                      '- Sứ mệnh của Reels Replay là kết nối cộng đồng thông qua những video ngắn, bài viết sáng tạo và độc đáo.'),
                ],
              ),
              SizedBox(height: 16),

              // Mục 3: Các tính năng chính
              Text(
                'Các tính năng chính:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      '- Tạo và chia sẻ các video ngắn, bài viết đầy sáng tạo và kết nối bạn bè.'),
                  Text(
                      '- Khám phá những video ngắn mới từ cộng đồng Reels Replay.'),
                  Text(
                      '- Tương tác với các video, bài viết bằng cách thích, bình luận và đánh dấu.')
                ],
              ),
              SizedBox(height: 16),

              // Mục 4: Điểm nổi bật
              Text(
                'Điểm nổi bật:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('- Giao diện đơn giản, dễ sử dụng.'),
                  Text('- Cộng đồng người dùng năng động và sáng tạo.'),
                  Text('- Nhiều tính năng độc đáo và mới lạ.')
                ],
              ),
              SizedBox(height: 16),

              // Mục 5: Đội ngũ phát triển
              Text(
                'Đội ngũ phát triển:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Reels Replay là đồ án môn học Phát triển ứng dụng di động của trường Đại học Công nghệ Thông tin - ĐHQG HCM, được phát triển bởi nhóm sinh viên đầy năng động có đam mê với lập trình và video.'),
              SizedBox(height: 16),

              // Mục 6: Liên hệ
              Text(
                'Mọi thắc mắc xin liên hệ:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Email: reelsreplay.helper@gmail.com'),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
