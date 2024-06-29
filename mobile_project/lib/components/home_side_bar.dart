import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/components/comment_page.dart';
import 'package:mobile_project/models/video_model.dart'; // Thay đổi này

class HomeSideBar extends StatefulWidget {
  const HomeSideBar({super.key, required this.video});

  final VideoModel video;

  @override
  State<HomeSideBar> createState() => _HomeSideBarState();
}

class _HomeSideBarState extends State<HomeSideBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final Map<String, bool> _isActive = {
    'heart': false,
    'bookmark': false
  }; // Track individual item states

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
        .copyWith(fontSize: 12, color: const Color(0xffF1FCFD));
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // _sideBarItem('heart', widget.video.likes.toString(), style), // Điều chỉnh này
        // _sideBarComment('comment', widget.video.comments.toString(), style), // Điều chỉnh này
        // _sideBarItem('bookmark', widget.video.bookmarks.toString(), style), // Điều chỉnh này
        _sideBarItem('heart', "100", style),
        _sideBarComment('comment', '20', style),
        _sideBarItem('bookmark', '10', style),
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 16.0, left: 8.0, right: 8.0),
          child: AnimatedBuilder(
            animation: _animationController,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 35,
                  width: 35,
                  child: Image.asset('assets/images/disc.png'),
                ),
              ],
            ),
            builder: (context, child) {
              return Transform.rotate(
                angle: 2 * pi * _animationController.value,
                child: child,
              );
            },
          ),
        )
      ],
    );
  }

  _sideBarItem(String iconName, String label, TextStyle style) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isActive[iconName] =
              !_isActive[iconName]!; // Toggle individual state
        });
      },
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/icons/${_isActive[iconName]! ? '${iconName}_filled' : iconName}.svg',
            width: 30,
            height: 30,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            label,
            style: style,
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  _sideBarComment(String iconName, String label, TextStyle style) {
    return GestureDetector(
      onTap: () {
        showBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return DraggableScrollableSheet(
                maxChildSize: 0.8,
                initialChildSize: 0.8,
                minChildSize: 0.3,
                builder: (context, scrollController) {
                  return const CommentPage();
                },
              );
            });
      },
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/icons/$iconName.svg',
            width: 25,
            height: 25,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            label,
            style: style,
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
