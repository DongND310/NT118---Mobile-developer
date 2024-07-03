import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VideoSearch extends StatelessWidget {
  final String title;
  final String numLike;
  final String account;
  final String thumbnailPath;
  VideoSearch(this.title, this.numLike, this.account, this.thumbnailPath);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2 - 16,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(style: BorderStyle.none, width: 2),
            ),
            child: ClipRect(
              child: Image.file(  File(thumbnailPath)
                ,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(title,
              maxLines: 1, // Giới hạn số dòng hiển thị
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                account,
                style: const TextStyle(fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    "assets/icons/heart.svg",
                    color: Colors.black,
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    numLike,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 9),
        ],
      ),
    );
  }
}
