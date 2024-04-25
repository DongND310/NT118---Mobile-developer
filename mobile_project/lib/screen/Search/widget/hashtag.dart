import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Hashtag extends StatelessWidget {
  final String hashtag;
  Hashtag(this.hashtag);
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/hashtag.svg',
              width: 25,
              height: 25,),
            Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hashtag,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("description",style: TextStyle(fontSize: 15))
                    ]
                )
            )
          ],
        ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [IconButton(
              icon: SvgPicture.asset(
                'assets/icons/video.svg',
                width: 25,
                height: 25,
              ),
              onPressed: () {

              })],
        ))
      ],
    );
  }
}
