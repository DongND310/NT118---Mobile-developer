import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchScreen extends StatefulWidget {
  final List<String> SearchHistory = [
    "1",
    "2",
    "3",
    "4",
    "5 ",
    "1",
    "2",
    "3",
    "4",
    "5 ",
    "1",
    "2",
    "3",
    "4",
    "5 ",
    "1",
    "2",
    "3",
    "4",
    "5 ",
    "1",
    "2",
    "3",
    "4",
    "5 "
  ];
  final bool showmore = false;
  final bool showresult= false;
  final String account ="Account";
  final String descript ="description";
  final List<String> hashtag = ["#hastag1", "#hashtag2"];
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late bool _show;
  late bool _showresult;
  @override
  void initState() {
    _show = widget.showmore;
    _showresult = widget.showresult;
    super.initState();
  }
  void _searchButtonPressed() {
    setState(() {
      _showresult = true;
    });
  }
  Widget _buildResultSection() {
    return Visibility(
        visible: _showresult,
        child: SizedBox(
            height:double.maxFinite ,
            child: DefaultTabController(
                length: 4,
                child: Column(
                    children: [
                      Container(
                        child: const TabBar(
                          tabs: [
                            Tab(text: "Thịnh hành"),
                            Tab(text: "Tài khoản"),
                            Tab(text: "Video"),
                            Tab(text: "Hashtag"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: double.maxFinite,
                        child: TabBarView(
                          children: [
                            Container(
                                height: double.maxFinite,
                                padding:  EdgeInsets.only(left: 10, right: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Tài khoản",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            TextButton(onPressed: (){},
                                                child: Text(
                                                  "Xem thêm", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                                                )
                                            ),
                                            SvgPicture.asset(
                                              "assets/icons/more.svg",
                                              width: 30,
                                              height: 30,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.black, width: 2),
                                          ),
                                          child: ClipOval(
                                            child: Image.network(
                                              'https://i.pinimg.com/736x/fd/7f/48/fd7f480aa83946195f004f34a0da9ad8.jpg',
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 40),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(widget.account, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                            Text(widget.descript, style: TextStyle(fontSize: 20)),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                )
                            ),
                            Container(
                              child: Text("Thịnh hành", textAlign: TextAlign.center,style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              child: Text("Thịnh hành", textAlign: TextAlign.center,style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              child: Text("Thịnh hành", textAlign: TextAlign.center,style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      )
                    ]
                )
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                padding:  EdgeInsets.only(left: 5, top: 30, right: 5),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/icons/ep_back.svg',
                              width: 30,
                              height: 30,
                            ),
                            onPressed: () {
                            },
                          ),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                SizedBox(
                                  height: 45,
                                  child: TextField(
                                    style: TextStyle(fontSize: 20),
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: SvgPicture.asset(
                                          'assets/icons/search.svg',
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      suffixIcon: Padding(
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child:
                                          IconButton(onPressed: (){
                                            setState(() {
                                              _showresult = false;
                                            });
                                          },
                                              icon: SvgPicture.asset(
                                                  'assets/icons/cancel.svg'
                                              )
                                          )
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _searchButtonPressed();
                            },
                            child: const Text(
                              "Tìm kiếm",
                              style: TextStyle(
                                color: Color(0xFF107BFD),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: !_showresult,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemExtent: 35,
                                itemCount: _show ? widget.SearchHistory.length : 3,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/history.svg',
                                            width: 25,
                                            height: 25,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              widget.SearchHistory[index],
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: SvgPicture.asset(
                                          'assets/icons/cancel.svg',
                                          width: 25,
                                          height: 25,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            widget.SearchHistory.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Visibility(
                              visible: !_show,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _show = true;
                                      });
                                    },
                                    child: const Text(
                                      "Xem thêm",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF107BFD),
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: _show,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                    },
                                    child: const Text(
                                      "Xóa tất cả",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF107BFD),
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Khám phá",
                                style: TextStyle(
                                  color: Color(0xFF107BFD),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListView.builder(//video
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.hashtag.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15.0),
                                            child: Text(
                                              widget.hashtag[index],
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [

                                        ],
                                      )
                                    ],
                                  );
                                }
                            )
                          ],
                        ),
                      ),
                      _buildResultSection()
                    ]
                ),
              ),
            )
        )
    );
  }
}
