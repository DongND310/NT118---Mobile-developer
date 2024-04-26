import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/models/video.dart';

class HomeSideBar extends StatefulWidget {
  const HomeSideBar({super.key, required this.video});
  final Video video;
  @override
  State<HomeSideBar> createState() => _HomeSideBarState();
}

class _HomeSideBarState extends State<HomeSideBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontSize: 8, color: const Color(0xffF1FCFD));
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _sideBarItem('heart', widget.video.likes, style),
        _sideBarItem('comment', widget.video.comments, style),
        _sideBarItem('bookmark', widget.video.bookmarks, style),
        _sideBarItem('share', 'Share', style),
        Padding(
          //hiện ảnh của bản nhạc
          padding: const EdgeInsets.all(8.0),
          child: AnimatedBuilder(
              animation: _animationController,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 35,
                    width: 35,
                    child: Image.asset('assets/disc.png'),
                  ),
                  CircleAvatar(
                    radius: 10,
                    backgroundImage: NetworkImage(widget.video.audioImageUrl),
                  ),
                ],
              ),
              builder: (context, child) {
                return Transform.rotate(
                  angle: 2 * pi * _animationController.value,
                  child: child,
                );
              }),
        )
      ],
    );
  }

  _sideBarItem(String iconName, String label, TextStyle style) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/$iconName.svg',
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          label,
          style: style,
        )
      ],
    );
  }
}
