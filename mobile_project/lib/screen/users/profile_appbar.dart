import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/screen/users/proflie_setting.dart';

class CustomProfileAppBar extends StatelessWidget {
  CustomProfileAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      pinned: true,
      floating: true,
      snap: true,
      backgroundColor: Colors.white,
      elevation: 0.5,
      title: Text(
        '@username',
        style: const TextStyle(
          fontSize: 18,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileSettingPage(),
              ),
            );
          },
          icon: SvgPicture.asset(
            'assets/icons/setting_list.svg',
            width: 18,
          ),
        ),
      ],
    );
  }
}
