import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VideoSearch extends StatelessWidget{
  final String title;
  final String numLike;
  final String account;
  VideoSearch(this.title, this.numLike, this.account);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2 - 16,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(style: BorderStyle.none,width: 2),
            ),
            child: ClipRect(
              child: Image.network(
                'https://i.pinimg.com/736x/fd/7f/48/fd7f480aa83946195f004f34a0da9ad8.jpg',
                width: MediaQuery.of(context).size.width / 2 - 16,
                height: 160,
                fit: BoxFit.cover,),),
          ),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(account,style: TextStyle(fontSize: 18),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    "assets/icons/heart.svg",
                    width: 20,
                    height: 20,
                  ),
                  Text(numLike,style: TextStyle(fontSize: 18),)
                ],
              )
            ],
          )
        ],
      ),
    );
  }

}