import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class MoreScreen extends StatefulWidget{
  final String userName;
  MoreScreen({required this.userName});
  @override
  State<StatefulWidget> createState()=> _MoreState();
}

class _MoreState extends State<MoreScreen>{

  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/ep_back.svg',
              width: 30,
              height: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                'https://i.pinimg.com/736x/fd/7f/48/fd7f480aa83946195f004f34a0da9ad8.jpg',
                height: 150,
                width: 150,
              ),
            ),
            SizedBox(height: 15,),
            Text(widget.userName, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xFF000144)),),
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [IconButton(onPressed: (){},
                      icon: Icon(Icons.account_circle_outlined,color: Color(0xFF107BFD),size: 40,)),
                    Text("Trang cá nhân",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Color(0xFF000144)),)
                  ],
                ),
                SizedBox(width: 100,),
                Column(
                  children: [
                    IconButton(onPressed: (){
                      setState(() {
                        _isPressed= !_isPressed;
                      });
                    },
                        icon: _isPressed? Icon(Icons.notifications_none_outlined,color: Color(0xFF107BFD),size: 40,)
                            : Icon(Icons.notifications_off_outlined,color: Color(0xFF107BFD),size: 40,)

                    ),
                    Text(_isPressed ? "Tắt thông báo": "Bật thông báo",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Color(0xFF000144)),)
                  ],
                )
              ],
            )
          ],
        )
    );
  }

}