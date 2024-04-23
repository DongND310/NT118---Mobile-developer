import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountDetail extends StatelessWidget{
  @override
  final String account;
  final String descript;

  AccountDetail(this.account, this.descript);

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.only(top:5, bottom:5 ),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(style: BorderStyle.none, width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                'https://i.pinimg.com/736x/fd/7f/48/fd7f480aa83946195f004f34a0da9ad8.jpg',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          )
        ),
        SizedBox(width: 40),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, // Canh chỉnh văn bản theo chiều dọc giữa dòng
            children: [
              Text(account, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(descript, style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ],
    );
  }
}