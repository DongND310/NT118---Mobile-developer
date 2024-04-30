import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/screen/Search/widget/account_detail.dart';
import 'package:mobile_project/screen/Search/widget/hashtag.dart';
import 'package:mobile_project/screen/Search/widget/search_history_detail.dart';
import 'package:mobile_project/screen/Search/widget/suggest_detail.dart';
import 'package:mobile_project/screen/Search/widget/video_search.dart';

import 'hashtagview.dart';

class SearchScreen extends StatefulWidget {
  final List<String> searchhistory = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9"
  ];
  final bool showmore = false;
  final bool showresult = false;
  final List<String> account = [
    "Account1",
    "Account1",
    "Account1",
    "Account1",
    "Account1",
    "Account1",
    "Account1",
    "Account1",
    "Account1",
    "Account1"
  ];
  final String descript = "description";
  final List<String> hashtag = [
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2",
    "#hastag1",
    "#hashtag2"
  ];
  final String title = "Title";
  final String numLike = "1M";

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late bool _showresult;
  List<String> _search = [];
  TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    _showresult = widget.showresult;
    super.initState();
  }

  void _searchButtonPressed() {
    setState(() {
      _showresult = true;
    });
  }

  Widget _buildResultSection() {
    return TabBarView(children: [
      SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tài khoản",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Xem thêm",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/icons/more.svg",
                      width: 30,
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
            AccountDetail(widget.account[1], widget.descript),
            Text(
              "Video",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisExtent: 218,
              ),
              itemCount: 15,
              itemBuilder: (BuildContext context, int index) {
                return VideoSearch(
                  widget.title,
                  widget.numLike,
                  widget.account[1],
                );
              },
            )
          ],
        ),
      )),
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemExtent: 100,
                      itemCount: widget.account.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AccountDetail(
                            widget.account[index], widget.descript);
                      })),
            ]),
      ),
      Container(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: GridView.builder(
          physics: PageScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisExtent: 218,
          ),
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return VideoSearch(
              widget.title,
              widget.numLike,
              widget.account[1],
            );
          },
        ),
      )),
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: 50 * widget.hashtag.length.toDouble(),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemExtent: 50,
                      itemCount: widget.hashtag.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HashTagScreen(
                                          widget.hashtag[index])));
                            },
                            child: Hashtag(widget.hashtag[index]));
                      }),
                )),
          ],
        ),
      )
    ]);
  }

  Widget _searchListView() {
    return ListView.builder(
        itemCount: _search.length,
        itemBuilder: (ctx, index) {
          return Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        child: SvgPicture.asset(
                          'assets/icons/search.svg',
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(_search[index]),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/icons/cancel.svg',
                    ),
                  ),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                'assets/icons/ep_back.svg',
                width: 30,
                height: 30,
              ),
            ),
            title: SizedBox(
              height: 30,
              child: TextField(
                controller: _textEditingController,
                onChanged: (value) {
                  setState(() {
                    _search = widget.account
                        .where((element) => element.toLowerCase().contains(
                            _textEditingController.text.toLowerCase()))
                        .toList();
                  });
                },
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Transform.scale(
                      scale: 0.6,
                      child: SvgPicture.asset(
                        'assets/icons/search.svg',
                      ),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _showresult = false;
                          _textEditingController.clear();
                        });
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/cancel.svg',
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _searchButtonPressed();
                },
                child: const Text(
                  "Tìm kiếm",
                  style: TextStyle(
                    color: Color(0xFF107BFD),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            bottom: _showresult
                ? TabBar(
                    tabs: [
                      Tab(text: "Thịnh hành"),
                      Tab(text: "Tài khoản"),
                      Tab(text: "Video"),
                      Tab(text: "Hashtag"),
                    ],
                  )
                : PreferredSize(
                    child: Container(), // Container
                    preferredSize: Size.fromHeight(0.0),
                  ),
          ),
          body: _showresult
              ? _buildResultSection()
              : _textEditingController.text.isNotEmpty
                  ? _searchListView()
                  : SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchHistoryDetail(
                              widget.searchhistory, widget.showmore),
                          const Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              "Khám phá",
                              style: TextStyle(
                                color: Color(0xFF107BFD),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SuggestDetail(widget.hashtag)
                        ],
                      ),
                    ),
        ));
  }
}