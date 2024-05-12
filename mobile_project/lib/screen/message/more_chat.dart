import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class MoreScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String chatterImg;

  MoreScreen(
      {required this.receiverId,
      required this.receiverName,
      required this.chatterImg});
  @override
  State<StatefulWidget> createState() => _MoreState();
}

class _MoreState extends State<MoreScreen> {
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
        body: Padding(
          padding: const EdgeInsets.only(top: 0.0, left: 40, right: 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: widget.chatterImg != null
                    ? NetworkImage(widget.chatterImg)
                    : Image.asset('assets/images/default_avt.png').image,
              ),
              SizedBox(
                height: 35,
              ),
              Text(
                widget.receiverName,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.account_circle_outlined,
                            color: Color(0xFF107BFD),
                            size: 40,
                          )),
                      Text(
                        "Trang cá nhân",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.blue),
                      )
                    ],
                  ),
                  // SizedBox(
                  //   width: 100,
                  // ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _isPressed = !_isPressed;
                            });
                          },
                          icon: _isPressed
                              ? Icon(
                                  Icons.notifications_none_outlined,
                                  color: Color(0xFF107BFD),
                                  size: 40,
                                )
                              : Icon(
                                  Icons.notifications_off_outlined,
                                  color: Color(0xFF107BFD),
                                  size: 40,
                                )),
                      Text(
                        _isPressed ? "Tắt thông báo" : "Bật thông báo",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.blue),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}
