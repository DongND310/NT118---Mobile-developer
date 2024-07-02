import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/screen/users/proflie_setting.dart';

class PolicyScreen extends StatelessWidget {
  PolicyScreen({super.key});

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
          'Chính sách',
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
              // Mục 1: Mục đích
              Text(
                'Mục đích:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Chính sách này nhằm mục đích thông báo cho người dùng về cách thức ứng dụng thu thập, sử dụng và bảo mật thông tin cá nhân của họ.',
              ),
              SizedBox(height: 16),

              // Mục 2: Phạm vi áp dụng
              Text(
                'Phạm vi áp dụng:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Chính sách này áp dụng cho tất cả người dùng sử dụng ứng dụng Reels Replay.',
              ),
              SizedBox(height: 16),

              // Mục 3: Thông tin thu thập
              Text(
                'Thông tin thu thập:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Ứng dụng có thể thu thập các loại thông tin sau đây của người dùng:',
              ),
              SizedBox(height: 8),
              // Liệt kê chi tiết các loại thông tin thu thập
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '- Thông tin cá nhân: Tên đầy đủ, số điện thoại, email, địa chỉ, ngày sinh, giới tính, ảnh đại diện'),
                  Text('- Thông tin đăng ký: Tên tài khoản, mật khẩu.'),
                  Text(
                      '- Thông tin về hoạt động sử dụng: Video đã xem, video đã đăng tải, bài viết đã đăng tải, bình luận, tương tác với người dùng khác.'),
                  Text(
                      '- Thông tin thiết bị: Hệ điều hành, phiên bản ứng dụng, loại thiết bị.'),
                ],
              ),
              SizedBox(height: 16),

              // Mục 4: Mục đích sử dụng thông tin
              Text(
                'Mục đích sử dụng thông tin:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Ứng dụng sử dụng thông tin thu thập được cho các mục đích sau:',
              ),
              SizedBox(height: 8),
              // Liệt kê chi tiết
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- Cung cấp và cải thiện dịch vụ cho người dùng.'),
                  Text(
                      '- Gửi thông báo cho người dùng về các cập nhật, sự kiện và khuyến mãi.'),
                  Text(
                      '- Giải quyết các vấn đề kỹ thuật và hỗ trợ người dùng.'),
                  Text(
                      '- Phân tích xu hướng và hành vi sử dụng của người dùng.'),
                ],
              ),
              SizedBox(height: 16),
              // Mục 5: Chia sẻ thông tin:
              Text(
                'Chia sẻ thông tin:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Ứng dụng có thể chia sẻ thông tin cá nhân của người dùng cho các bên thứ ba trong các trường hợp sau:',
              ),
              SizedBox(height: 8),
              // Liệt kê chi tiết
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- Khi người dùng đồng ý cho phép chia sẻ.'),
                  Text(
                      '- Khi được yêu cầu bởi pháp luật hoặc cơ quan có thẩm quyền.'),
                  Text(
                      '- Để thực hiện các dịch vụ cho người dùng, ví dụ như thanh toán, gửi email.'),
                ],
              ),
              SizedBox(height: 16),
              // Mục 7: Bảo mật thông tin
              Text(
                'Bảo mật thông tin:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Ứng dụng cam kết bảo vệ thông tin cá nhân của người dùng bằng các biện pháp bảo mật phù hợp, bao gồm:',
              ),
              SizedBox(height: 8),
              // Liệt kê chi tiết
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- Mã hóa dữ liệu.'),
                  Text('- Lưu trữ dữ liệu an toàn.'),
                  Text('- Hạn chế truy cập vào dữ liệu.'),
                  Text('- Đào tạo nhân viên về bảo mật thông tin.'),
                ],
              ),
              SizedBox(height: 16),
              // Mục 8: Quyền của người dùng
              Text(
                'Quyền của người dùng:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Người dùng có các quyền sau đây liên quan đến thông tin cá nhân của họ:',
              ),
              SizedBox(height: 8),
              // Liệt kê chi tiết các loại thông tin thu thập
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- Quyền truy cập vào thông tin cá nhân của họ.'),
                  Text(
                      '- Quyền yêu cầu sửa đổi hoặc xóa thông tin cá nhân của họ.'),
                  Text(
                      '- Quyền yêu cầu giới hạn việc xử lý thông tin cá nhân của họ.'),
                  Text('- Quyền phản đối việc xử lý thông tin cá nhân của họ.'),
                  Text('- Quyền yêu cầu chuyển giao thông tin cá nhân của họ.'),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Người dùng có thể thực hiện các quyền của mình bằng cách liên hệ với bộ phận hỗ trợ của ứng dụng qua reelsreplay.helper@gmail.com',
              ),
              SizedBox(height: 16),
              // Mục 9: Thay đổi chính sách
              Text(
                'Thay đổi chính sách:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Ứng dụng có thể thay đổi chính sách này bất cứ lúc nào. Người dùng sẽ được thông báo về các thay đổi thông qua ứng dụng hoặc email.',
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
