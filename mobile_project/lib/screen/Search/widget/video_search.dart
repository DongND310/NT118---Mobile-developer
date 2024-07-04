import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoSearch extends StatefulWidget {
  final String title;
  final String numLike;
  final String videoUrl;
  final String account;
  VideoSearch(this.title, this.numLike, this.videoUrl, this.account);

  @override
  State<VideoSearch> createState() => _VideoSearchState();
}

class _VideoSearchState extends State<VideoSearch> {
  String? _thumbnailUrl;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: widget.videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 200,
      maxWidth: 200,
      quality: 75,
    );
    setState(() {
      _thumbnailUrl = thumbnailPath;
    });
  }

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
              child: _thumbnailUrl != null
                  ? Image.file(
                      File(_thumbnailUrl!),
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/video_bg.jpg',
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          Text(widget.title,
              maxLines: 1, // Giới hạn số dòng hiển thị
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.black87)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.account,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
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
                    widget.numLike,
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
