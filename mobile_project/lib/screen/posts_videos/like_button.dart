import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LikeButton extends StatelessWidget {
  bool isLiked;
  void Function()? onTap;

  LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        isLiked ? 'assets/icons/post_liked.svg' : 'assets/icons/post_like.svg',
        width: 20,
      ),
    );
  }
}
