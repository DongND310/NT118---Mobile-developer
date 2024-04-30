import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/screen/Follow/search_bar.dart';

import '../Search/widget/account_detail.dart';

class ListFollowerScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_ListFollowerState();
  final List<String>account =["Account1","Ái Thủy","TAT","AIIII","Account1","Account1","Account1","Account1","Account1","Account1"];

}

class _ListFollowerState extends State<ListFollowerScreen> {
  bool _isPressed=false;
  List<String>_search=[];
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3,
        child: Scaffold(
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
            title: Text("Username",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Color(0xFF000141))),
            centerTitle: true,
            bottom: TabBar(tabs: [
              Tab(text: "Follower 500K"),
              Tab(text: "Following 100K"),
              Tab(text: "Bạn bè 11K"),
            ],
              unselectedLabelColor: Colors.black54,
              indicatorColor: Color(0xFF000144),
              labelColor: Color(0xFF000144),
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SearchFollowerBar((value) {
                        setState(() {
                          _search = widget.account
                              .where((element) => element.toLowerCase().contains(_textEditingController.text.toLowerCase())).toList();
                        });
                      }, _textEditingController),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(), // Đặt physics này để ListView không cuộn
                        shrinkWrap: true,
                        itemExtent: 100,
                        itemCount: _textEditingController.text.isNotEmpty? _search.length: widget.account.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: AccountDetail(_textEditingController.text.isNotEmpty?_search[index]: widget.account[index], ""),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isPressed = !_isPressed;
                                  });
                                },
                                style: ButtonStyle (
                                  minimumSize: MaterialStateProperty.all<Size>(
                                    Size(125, 35),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(_isPressed? Colors.grey: Color(0xFF000144)),
                                  foregroundColor: MaterialStateProperty.all<Color>(_isPressed? Colors.black: Colors.white),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                ),
                                child: Text('Follow'),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SearchFollowerBar((value) {
                        setState(() {
                          _search = widget.account
                              .where((element) => element.toLowerCase().contains(_textEditingController.text.toLowerCase())).toList();
                        });
                      }, _textEditingController),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(), // Đặt physics này để ListView không cuộn
                        shrinkWrap: true,
                        itemExtent: 100,
                        itemCount: _textEditingController.text.isNotEmpty? _search.length: widget.account.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: AccountDetail(_textEditingController.text.isNotEmpty?_search[index]: widget.account[index], ""),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isPressed = !_isPressed;
                                  });
                                },
                                style: ButtonStyle (
                                  minimumSize: MaterialStateProperty.all<Size>(
                                    Size(125, 35),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(_isPressed? Colors.grey: Color(0xFF000144)),
                                  foregroundColor: MaterialStateProperty.all<Color>(_isPressed? Colors.black: Colors.white),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                child: Text('Follow'),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SearchFollowerBar((value) {
                        setState(() {
                          _search = widget.account
                              .where((element) => element.toLowerCase().contains(_textEditingController.text.toLowerCase())).toList();
                        });
                      }, _textEditingController),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(), // Đặt physics này để ListView không cuộn
                        shrinkWrap: true,
                        itemExtent: 100,
                        itemCount: _textEditingController.text.isNotEmpty? _search.length: widget.account.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: AccountDetail(_textEditingController.text.isNotEmpty?_search[index]: widget.account[index], ""),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isPressed = !_isPressed;
                                  });
                                },
                                style: ButtonStyle (
                                  minimumSize: MaterialStateProperty.all<Size>(
                                    Size(125, 35),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(_isPressed? Colors.grey: Color(0xFF000144)),
                                  foregroundColor: MaterialStateProperty.all<Color>(_isPressed? Colors.black: Colors.white),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                child: Text('Bạn bè'),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),

        )
    );
  }
}